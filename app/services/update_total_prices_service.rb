class UpdateTotalPricesService
  def initialize(item: nil, order:)
    @order_item = item
    @order = order
  end

  def call
    update_order_item_total_price if @order_item
    update_order_total_price
  end

  private

  def update_order_item_total_price
    @order_item.update(total_price: @order_item.quantity * @order_item.book.price)
  end

  def update_order_total_price
    @order.update(total_price: @order.order_items.includes(:book).map(&:total_price).sum)
  end
end
