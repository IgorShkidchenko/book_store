class Users::SessionsController < Devise::SessionsController
  include BackUrl
  before_action :set_cookies, only: %i[new create]
  after_action :update_order, only: :create

  def update_order
    user = current_user
    current_order.update(user_id: user.id) if session[:order_id] && !user.orders.ids.include?(session[:order_id])
  end
end
