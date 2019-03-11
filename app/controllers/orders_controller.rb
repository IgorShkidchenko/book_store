class OrdersController < ApplicationController
  include Rectify::ControllerHelpers

  load_resource only: :show
  authorize_resource
  decorates_assigned :order_items, :orders, :order

  def index
    @orders = Orders::FilterQuery.call(user: current_user, params: params)
    present(MyOrdersPresenter.new(user: current_user, params: params, orders: @orders))
  end

  def show
    @order_items = Orders::OrderItemsQuery.call(@order)
  end
end
