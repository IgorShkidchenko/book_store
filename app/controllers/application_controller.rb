class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_header_variables

  helper_method :current_order

  private

  def set_header_variables
    @categories = Category.all
  end

  def current_order
    return current_user.orders.where(order_status_id: 1).last if user_signed_in? && check_user_order

    session[:order_id] ? Order.find(session[:order_id]) : Order.new(order_status_id: 1, user_id: current_user&.id)
  end

  def check_user_order
    current_user.orders.where(order_status_id: 1).present?
  end
end
