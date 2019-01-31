class UpdateTotalPricesService
  def initialize(order_item: nil, order:)
    @order_item = order_item
    @order = order
  end

  def call
    update_order_item_total_price if @order_item
    update_order_subtotal_price
    update_order_total_price
  end

  private

  def update_order_item_total_price
    @order_item.update(total_price: @order_item.quantity * @order_item.book.price)
  end

  def update_order_subtotal_price
    @order.update(subtotal_price: @order.order_items.includes(:book).map(&:total_price).sum)
  end

  def update_order_total_price
    @order.coupon ? @order.update(total_price: price_with_coupon) : @order.update(total_price: @order.subtotal_price)
  end

  def price_with_coupon
    @order.subtotal_price - @order.coupon.discount
  end
end
