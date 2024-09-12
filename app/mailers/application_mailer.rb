class ApplicationMailer < ActionMailer::Base
  default from: "Todo <noreply@odds.team>"
  layout "mailer"
end
