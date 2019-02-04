class ApplicationController < ActionController::Base
  ORDER_IN_PROGRESS_ID = 1

  include Rectify::ControllerHelpers
  before_action :set_header_presenter
  protect_from_forgery with: :exception
  helper_method :current_order

  private

  def set_header_presenter
    present HeaderPresenter.new(categories: Category.all)
  end

  def current_order
    return @user_order if user_have_order_in_progress?

    order_id = session[:order_id]
    order_id ? Order.find_by(id: order_id) : Order.new(user_id: current_user&.id)
  end

  def user_have_order_in_progress?
    return unless user_signed_in?

    @user_order = Order.find_by(order_status_id: ORDER_IN_PROGRESS_ID, user_id: current_user.id)
  end
end
