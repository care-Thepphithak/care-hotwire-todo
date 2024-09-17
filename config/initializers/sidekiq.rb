Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL_LOCAL") { "redis://redis:6379/0" } }
  config.on(:startup) do
      Rails.logger.info "Time zone: #{Time.zone}"
      Rails.logger.info "Current time in #{Time.zone}: #{Time.zone.now}\n=================================="
  end
end
