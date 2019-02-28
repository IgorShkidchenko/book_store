class OrderItemsController < ApplicationController
  decorates_assigned :order_items

  before_action :set_order
  before_action :set_order_item, only: %i[update destroy]

  respond_to :js

  def index
    @order_items = OrderItemsQuery.new(@order).call
    respond_to :html
  end

  def create
    new_item = OrderItem::NewService.new(params: order_item_params, order: @order)
    new_item.call ? session[:order_id] ||= @order.id : flash.now[:danger] = I18n.t('cart.errors.unknow')
  end

  def update
    updater = OrderItem::QuantityUpdaterService.new(@order_item, params)
    flash.now[:danger] = I18n.t('cart.errors.min_quantity') unless updater.call
  end

  def destroy
    flash.now[:danger] = I18n.t('cart.errors.unknow') unless @order_item.destroy
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id)
  end

  def set_order
    @order = current_order
  end

  def set_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end
end
