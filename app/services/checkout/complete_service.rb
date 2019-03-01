class Checkout::CompleteService
  FIRST_ORDER_NUMBER_SYMBOL = '#R'.freeze
  CURRENT_DATE = '%Y%m%d%H%M%S'.freeze

  def initialize(order)
    @order = order
  end

  def call
    @order.update(number: generate_order_number) if @order.in_progress!
    # send email
  end

  private

  def generate_order_number
    FIRST_ORDER_NUMBER_SYMBOL + Time.now.strftime(CURRENT_DATE)
  end
end
