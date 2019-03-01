class Orders::PriceCalculatorService
  ZERO_AMOUNT = 0

  def initialize(order)
    @order = order
  end

  def subtotal_price
    @subtotal_price ||= (@order.order_items.includes(:book).sum { |item| item.book_price * item.quantity }).round(2)
  end

  def total_price
    (subtotal_price - coupon_amount + delivery_method_amount).round(2)
  end

  private

  def coupon_amount
    @order.coupon&.discount || ZERO_AMOUNT
  end

  def delivery_method_amount
    @order.delivery_method&.cost || ZERO_AMOUNT
  end
end
