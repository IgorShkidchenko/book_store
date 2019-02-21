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
    "#R#{SecureRandom.hex(4)}#{@order.id}"
  end
end
