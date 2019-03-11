class OrderItems::QuantityUpdaterService < ApplicationService
  ADD_COMMAND = 'add'.freeze
  MIN_QUANTITY = 1

  def initialize(item:, params:)
    @order_item = item
    @params = params
    @old_quantity = @order_item.quantity
  end

  def call
    @params.dig(:order_item, :command).eql?(ADD_COMMAND) ? increment : decrement
    @old_quantity != @order_item.quantity
  end

  private

  def increment
    @order_item.increment!(:quantity)
  end

  def decrement
    @order_item.decrement!(:quantity) if @order_item.quantity > MIN_QUANTITY
  end
end
