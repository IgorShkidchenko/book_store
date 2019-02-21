class OrderDecorator < Draper::Decorator
  ZERO_AMOUNT = 0
  MONTH_NAME_TWO_DIGIT_DAY_FULL_YEAR = '%B %d, %Y'.freeze

  delegate_all
  delegate :name, :cost, to: :delivery_method, prefix: true
  delegate :email, to: :user, prefix: true

  def coupon_discount
    coupon ? I18n.t('price', price: coupon.discount) : ZERO_AMOUNT
  end

  def cart_count
    order_items.sum(&:quantity)
  end

  def creation_date
    created_at.strftime(MONTH_NAME_TWO_DIGIT_DAY_FULL_YEAR)
  end

  def subtotal_price
    I18n.t('price', price: new_subtotal_price)
  end

  def total_price
    I18n.t('price', price: new_total_price)
  end

  private

  def new_subtotal_price
    @new_subtotal_price ||= order_items.includes(:book).sum { |item| item.book_price * item.quantity }
  end

  def new_total_price
    new_subtotal_price - coupon_amount + delivery_method_amount
  end

  def coupon_amount
    coupon&.discount || ZERO_AMOUNT
  end

  def delivery_method_amount
    delivery_method&.cost || ZERO_AMOUNT
  end
end
