require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)

require 'carrierwave/orm/activerecord'

module BookStore
  class Application < Rails::Application
    config.load_defaults 5.2
    config.generators.assets = false
    config.generators.helper = false
    config.action_controller.include_all_helpers = false
  end
end
