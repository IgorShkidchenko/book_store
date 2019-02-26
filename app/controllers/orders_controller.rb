class OrdersController < ApplicationController
  LATEST = 'created_at desc'.freeze

  decorates_assigned :order_items

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items.order(LATEST).includes(book: :covers)
  end
end
