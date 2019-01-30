class ApplicationController < ActionController::Base
  ORDER_IN_PROGRESS_ID = 1

  protect_from_forgery with: :exception
  before_action :set_header_variables

  helper_method :current_order

  private

  def set_header_variables
    @categories = Category.all
  end

  def current_order
    return @user_order if user_have_order_in_progress?

    session[:order_id] ? Order.find(session[:order_id]) : Order.new(user_id: current_user&.id)
  end

  def user_have_order_in_progress?
    return unless user_signed_in?

    @user_order = current_user.orders.where(order_status_id: ORDER_IN_PROGRESS_ID).first
    @user_order.present?
  end
end
