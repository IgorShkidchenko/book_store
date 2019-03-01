class OrdersController < ApplicationController
  include Rectify::ControllerHelpers

  decorates_assigned :order_items, :orders, :order

  def index
    @user = current_user
    @orders = OrdersFilterQuery.new(user: @user, params: params).call
    present MyOrdersPresenter.new(user: @user, params: params, orders: @orders)
  end

  def show
    @order = Order.find_by(id: params[:id])
    @order_items = OrderItemsQuery.new(@order).call
  end
end
