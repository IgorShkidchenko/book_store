class OrderItemsController < ApplicationController
  ADD = 'add'.freeze

  before_action :set_order
  before_action :set_order_item, only: %i[update destroy]

  respond_to :js

  def create
    @order_item = NewOrderItemService.new(order_item_params, @order).call
    UpdateTotalPricesService.new(order_item: @order_item, order: @order).call
    session[:order_id] ||= @order.id
  end

  def update
    params[:order_item][:command] == ADD ? @order_item.increment!(:quantity) : @order_item.decrement!(:quantity)
    UpdateTotalPricesService.new(order_item: @order_item, order: @order).call
  end

  def destroy
    @order_item.destroy!
    UpdateTotalPricesService.new(order: @order).call
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id)
  end

  def set_order
    @order = current_order
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end
end
