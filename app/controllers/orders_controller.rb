class OrdersController < ApplicationController
  decorates_assigned :order_items

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items.order('created_at desc').includes(:book)
  end
end
