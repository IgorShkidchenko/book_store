class OrderItemsController < ApplicationController
  ADD_QUANTITY = 'add'.freeze

  before_action :set_order
  before_action :set_order_item, only: %i[update destroy]

  respond_to :js

  def create
    @order_item = NewOrderItemService.new(order_item_params, @order).call
    UpdateTotalPricesService.new(item: @order_item, order: @order).call
    session[:order_id] ||= @order.id
  end

  def update
    params[:order_item][:command] == ADD_QUANTITY ? @order_item.quantity += 1 : @order_item.quantity -= 1
    @order_item.save!
    UpdateTotalPricesService.new(item: @order_item, order: @order).call
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
    @order_item = @order.order_items.find(params[:id])
  end
end
