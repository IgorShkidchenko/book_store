class OrderItemsController < ApplicationController
  before_action :set_order
  before_action :set_order_item, only: %i[update destroy]

  respond_to :js

  def create
    @order_item = @order.order_items.find_by_book_id(order_item_params[:book_id])
    @order_item ? @order_item.update_quantity(order_item_params[:quantity].to_i) : create_new_item
    update_total_prices
    session[:order_id] ||= @order.id
  end

  def update
    params[:order_item][:action] == 'add' ? @order_item.quantity += 1 : @order_item.quantity -= 1
    @order_item.save
    update_total_prices
  end

  def destroy
    @order_item.destroy
    @order.update_total_price
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

  def update_total_prices
    @order_item.update_total_price
    @order.update_total_price
  end

  def create_new_item
    @order_item = @order.order_items.new(order_item_params)
  end
end
