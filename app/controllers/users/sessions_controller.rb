class Users::SessionsController < Devise::SessionsController
  include BackUrl
  before_action :set_cookies, only: %i[new create]
end
