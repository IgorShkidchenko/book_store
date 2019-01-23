class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_cookies, only: %i[new create]
end
