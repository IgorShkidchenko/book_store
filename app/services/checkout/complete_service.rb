class Checkout::CompleteService
  def initialize(order)
    @order = order
  end

  def call
    @order.update(number: generate_order_number) if @order.in_progress!
    # send email
  end

  private

  def generate_order_number
    "#R#{Time.now.strftime('%Y%m%d%H%M%S')}#{@order.id}"
  end
end
