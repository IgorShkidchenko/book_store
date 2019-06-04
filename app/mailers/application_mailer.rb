class ApplicationMailer < ActionMailer::Base
  DEFAULT_EMAIL = 'bookstore@example.com'.freeze
  DEFAULT_LAYOUT = 'mailer'.freeze

  default from: DEFAULT_EMAIL
  layout DEFAULT_LAYOUT
end
