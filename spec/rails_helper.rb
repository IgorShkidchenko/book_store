require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'carrierwave/test/matchers'
require 'cancan/matchers'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'rack_session_access/capybara'
require 'faker'
require 'devise'
require 'database_cleaner'

require "#{::Rails.root}/spec/support/macroses/controller_macros.rb"
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
