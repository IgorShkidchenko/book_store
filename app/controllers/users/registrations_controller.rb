class Users::RegistrationsController < Devise::RegistrationsController
  include BackUrl
  before_action :set_cookies, only: %i[new create]
end
