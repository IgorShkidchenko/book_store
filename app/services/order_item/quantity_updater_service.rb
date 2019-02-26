class OrderItem::QuantityUpdaterService
  ADD = 'add'.freeze
  MIN_QUANTITY = 1

  def initialize(order_item, params)
    @order_item = order_item
    @params = params
  end

  def call
    old_quantity = @order_item.quantity
    change_quantity
    old_quantity != @order_item.quantity
  end

  private

  def change_quantity
    return @order_item.increment!(:quantity) if @params[:order_item][:command] == ADD

    @order_item.decrement!(:quantity) if @order_item.quantity > MIN_QUANTITY
  end
end
