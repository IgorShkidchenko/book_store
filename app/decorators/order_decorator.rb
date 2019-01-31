class OrderDecorator < Draper::Decorator
  NO_DISCOUNT_QUANTITY = 0

  delegate_all

  def coupon_discount
    order.coupon ? I18n.t('price', price: order.coupon.discount) : NO_DISCOUNT_QUANTITY
  end
end
