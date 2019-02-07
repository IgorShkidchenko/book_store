module OmniAuthTestHelper
  def valid_facebook_login_setup
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123545',
                                                                  info: { email: Faker::Internet.email })
  end
end

RSpec.configure do |config|
  config.include OmniAuthTestHelper
end
