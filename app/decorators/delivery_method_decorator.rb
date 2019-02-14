class DeliveryMethodDecorator < Draper::Decorator
  delegate_all

  def delivery_days
    days = I18n.t('checkout.delivery_page.method_days', min: min_days, max: max_days)
    max_days.zero? ? I18n.t('checkout.delivery_page.zero_days') : days
  end
end
