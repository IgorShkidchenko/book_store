class Checkout::CompleteService
  FIRST_ORDER_NUMBER_SYMBOL = '#R'.freeze
  CURRENT_DATE = '%Y%m%d%H%M%S'.freeze

  def initialize(order)
    @order = order
  end

  def call
    final_updates if @order.in_progress!
    # send email
  end

  private

  def final_updates
    @order.update(number: generate_order_number)
    @order.coupon.update(used: true)
  end

  def generate_order_number
    FIRST_ORDER_NUMBER_SYMBOL + Time.now.strftime(CURRENT_DATE)
  end
end
