class OrderDecorator < Draper::Decorator
  NO_DISCOUNT_QUANTITY = 0

  delegate_all

  def coupon_discount
    coupon = order.coupon
    coupon ? I18n.t('price', price: coupon.discount) : NO_DISCOUNT_QUANTITY
  end

  def cart_count
    order.order_items.sum(&:quantity)
  end
end
