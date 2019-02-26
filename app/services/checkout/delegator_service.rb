class Checkout::DelegatorService
  def initialize(order:, step:, params:)
    @order = order
    @arguments = { order: order, step: step, params: params }
  end

  def call
    @order.editing? ? Checkout::UpdaterService.new(@arguments) : Checkout::CreaterService.new(@arguments)
  end
end
