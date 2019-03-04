Devise.setup do |config|
  config.secret_key = 'cb4b4119c6c456f5e66ad202e27a77bbc6a0fc9fa631f9f0dd404b57b80a2d68aba5d3c373387f1b19e211beb565ff1ab110e0c9aa03162f8dc13a2453eb8870'
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.omniauth :facebook, Rails.application.credentials.facebook[:api_id],
                             Rails.application.credentials.facebook[:api_secret]
end
