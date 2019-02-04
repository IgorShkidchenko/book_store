class Users::SessionsController < Devise::SessionsController
  include BackUrl
  before_action :set_cookies, only: %i[new create]
  after_action :update_order, only: :create

  private

  def update_order
    @user = current_user
    current_order.update(user_id: @user.id) if user_have_not_current_order?
  end

  def user_have_not_current_order?
    session[:order_id] && !Order.find_by(user_id: @user.id)
  end
end
