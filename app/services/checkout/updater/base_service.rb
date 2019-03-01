class Checkout::Updater::BaseService
  def initialize(order:, params:)
    @order = order
    @params = params
  end

  def call
    raise NotImplementedError
  end

  def valid?(condition = nil)
    @valid ||= condition
  end

  private

  def order_can_be_changed?
    valid? && !@order.editing?
  end
end
