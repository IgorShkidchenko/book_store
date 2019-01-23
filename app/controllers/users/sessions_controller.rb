class Users::SessionsController < Devise::SessionsController
  before_action :set_cookies, only: %i[new create]
end
