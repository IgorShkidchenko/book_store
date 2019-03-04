class OrdersController < ApplicationController
  include Rectify::ControllerHelpers

  load_resource only: :show
  authorize_resource
  decorates_assigned :order_items, :orders, :order

  def index
    @user = current_user
    @orders = OrdersFilterQuery.new(user: @user, params: params).call
    present MyOrdersPresenter.new(user: @user, params: params, orders: @orders)
  end

  def show
    @order_items = OrderItemsQuery.new(@order).call
  end
end
