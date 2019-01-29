class Users::RegistrationsController < Devise::RegistrationsController
  include BackUrl
  before_action :set_cookies, only: %i[new create]
  after_action :update_order, only: :create

  def update_order
    current_order.update(user_id: current_user.id) if session[:order_id]
  end
end
