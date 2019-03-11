class OrderItemsController < ApplicationController
  load_resource only: %i[update destroy]
  authorize_resource

  respond_to :js

  def index
    @order_items = Orders::OrderItemsQuery.call(current_order).decorate
    respond_to :html
  end

  def create
    result = OrderItems::NewCartItemService.call(params: order_item_params, order: current_order)
    return session[:order_id] ||= current_order.id if result

    flash.now[:danger] = I18n.t('cart.errors.unknow')
  end

  def update
    result = OrderItems::QuantityUpdaterService.call(item: @order_item, params: params)
    flash.now[:danger] = I18n.t('cart.errors.min_quantity') unless result
  end

  def destroy
    flash.now[:danger] = I18n.t('cart.errors.unknow') unless @order_item.destroy
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id)
  end
end
