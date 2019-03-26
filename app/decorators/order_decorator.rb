class OrderDecorator < Draper::Decorator
  ZERO_AMOUNT = 0.0
  MONTH_NAME_DAY_FULL_YEAR = '%B %d, %Y'.freeze

  delegate_all
  delegate :name, :cost, to: :delivery_method, prefix: true
  delegate :email, to: :user, prefix: true

  def coupon_discount
    coupon ? I18n.t('price', price: coupon.discount) : I18n.t('price', price: ZERO_AMOUNT)
  end

  def order_items_count
    order_items.sum(&:quantity)
  end

  def creation_date
    created_at.strftime(MONTH_NAME_DAY_FULL_YEAR)
  end

  def subtotal_price
    I18n.t('price', price: price_calculator.subtotal_price.round(2))
  end

  def total_price
    I18n.t('price', price: price_calculator.total_price.round(2))
  end

  def clone_address
    cloned_status = order.use_the_same_address
    h.check_box_tag 'order[clone_address]', cloned_status,
                    cloned_status, class: 'checkbox-input checkbox-class clone_check', hidden: true
  end

  def status
    aasm_state.capitalize.tr('_', ' ')
  end

  private

  def price_calculator
    @price_calculator ||= Orders::PriceCalculatorService.new(self)
  end
end
