class OrderDecorator < Draper::Decorator
  ZERO_AMOUNT = 0
  MONTH_NAME_DAY_FULL_YEAR = '%B %d, %Y'.freeze

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
    created_at.strftime(MONTH_NAME_DAY_FULL_YEAR)
  end

  def subtotal_price
    I18n.t('price', price: Order::PriceCalculatorService.new(self).subtotal_price)
  end

  def total_price
    I18n.t('price', price: Order::PriceCalculatorService.new(self).total_price)
  end

  def clone_address
    cloned = same_addresses?(self)
    h.check_box_tag 'order[clone_address]', (cloned ? true : false),
    (cloned ? true : false), class: 'checkbox-input checkbox-class clone_check', hidden: true
  end

  private

  def same_addresses?(order)
    return if order.addresses.empty?

    billing = order.addresses.billing.take.attributes.slice('first_name', 'last_name',
                                                      'street', 'country', 'zip', 'phone', 'city')
    shipping = order.addresses.shipping.take.attributes.slice('first_name', 'last_name',
                                                        'street', 'country', 'zip', 'phone', 'city')
    billing == shipping
  end
end
