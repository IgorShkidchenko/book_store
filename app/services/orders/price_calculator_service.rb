class Orders::PriceCalculatorService
  ZERO_AMOUNT = 0

  def initialize(order)
    @order = order
  end

  def subtotal_price
    @subtotal_price ||= @order.order_items.sum { |item| calculated_new_price(item) }
  end

  def total_price
    subtotal_price - coupon_amount + delivery_method_amount
  end

  private

  def calculated_new_price(item)
    item.book_price * item.quantity
  end

  def coupon_amount
    @order.coupon&.discount || ZERO_AMOUNT
  end

  def delivery_method_amount
    @order.delivery_method&.cost || ZERO_AMOUNT
  end
end
