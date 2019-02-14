class OrderDecorator < Draper::Decorator
  NO_DISCOUNT_QUANTITY = 0
  MONTH_NAME_TWO_DIGIT_DAY_FULL_YEAR = '%B %d, %Y'.freeze

  delegate_all
  delegate :name, :cost, to: :delivery_method, prefix: true
  delegate :email, to: :user, prefix: true

  def coupon_discount
    coupon ? I18n.t('price', price: coupon.discount) : NO_DISCOUNT_QUANTITY
  end

  def cart_count
    order_items.sum(&:quantity)
  end

  def creation_date
    created_at.strftime(MONTH_NAME_TWO_DIGIT_DAY_FULL_YEAR)
  end
end
