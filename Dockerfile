FROM ruby:3.3.2-alpine AS build
WORKDIR /myapp

# Set environment variables
ENV RAILS_ENV=production

# Install necessary packages to build gems and assets
RUN apk add --no-cache \
build-base \
git \
tzdata \
gcompat \
nodejs \
yarn \
postgresql-client \
libpq-dev

# Install only necessary gems and remove extensions
COPY Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development test' && \
bundle config --local build.pg --with-pg-config=/usr/bin/pg_config && \
bundle install --jobs 4 --retry 3 && \
rm -rf /usr/local/bundle/cache/*.gem && \
find /usr/local/bundle/gems/ -name "*.c" -delete && \
find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy application code
COPY . .

# Install node modules
RUN yarn install --frozen-lockfile

# Precompile assets and then remove unnecessary files
ARG SECRET_KEY_BASE
RUN SECRET_KEY_BASE=${SECRET_KEY_BASE} bundle exec rails assets:precompile && \
    rm -rf node_modules tmp/cache vendor/assets test spec

FROM ruby:3.3.2-alpine
WORKDIR /myapp

# Install runtime dependencies
RUN apk add --no-cache \
    sqlite-libs \
    tzdata \
    gcompat \
    postgresql-client \
    libpq-dev

# Copy built artifacts from the build stage
COPY --from=build /myapp /myapp/
COPY --from=build /usr/local/bundle /usr/local/bundle

# Set environment variables
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV RAILS_ENV=production

RUN chmod +x /myapp/bin/docker-entrypoint

# Run Docker entrypoint script
ENTRYPOINT ["/myapp/bin/docker-entrypoint"]

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]