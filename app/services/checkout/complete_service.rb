class Checkout::CompleteService < ApplicationService
  FIRST_ORDER_NUMBER_SYMBOL = '#R'.freeze
  CURRENT_DATE = '%Y%m%d%H%M%S'.freeze

  def initialize(order)
    @order = order
  end

  def call
    @order.in_progress!
    @order.update(number: generate_order_number)
    @order.coupon&.update(used: true)
    # OrderConfirmationMailerWorker.perform_async(@order.id)
  end

  private

  def generate_order_number
    FIRST_ORDER_NUMBER_SYMBOL + Time.now.strftime(CURRENT_DATE)
  end
end
