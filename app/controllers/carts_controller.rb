class CartsController < ApplicationController
  def show
    @order = current_order
    @order_items = @order.order_items.order('created_at desc').includes(:book)
  end
end
