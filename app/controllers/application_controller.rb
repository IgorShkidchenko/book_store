class ApplicationController < ActionController::Base
  include Rectify::ControllerHelpers
  before_action :set_header_presenter
  protect_from_forgery with: :exception
  helper_method :current_order

  private

  def set_header_presenter
    present HeaderPresenter.new(categories: Category.all)
  end

  def current_order
    order_id = session[:order_id]
    return Order.find_by(id: order_id) if order_id && !Order.find_by(id: order_id).in_progress?

    Order.new(user_id: current_user&.id)
  end
end
