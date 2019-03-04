AWS_ACL = 'private'.freeze
MAX_AGE = 'max-age=604800'.freeze

CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = Rails.application.credentials.aws[:bucket_name]
  config.aws_acl    = AWS_ACL

  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  config.aws_attributes = {
    expires:       1.week.from_now.httpdate,
    cache_control: MAX_AGE
  }

  config.aws_credentials = {
    access_key_id:     Rails.application.credentials.aws[:access_key_id],
    secret_access_key: Rails.application.credentials.aws[:secret_access_key],
    region:            Rails.application.credentials.aws[:region],
    stub_responses:    Rails.env.test?
  }
end
