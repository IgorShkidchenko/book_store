class NewOrderItemService
  def initialize(params:, order:)
    @params = params
    @order = order
    @order_item = @order.order_items.find_by(book_id: @params[:book_id])
  end

  def call
    @order_item ? update_quantity_and_return_item : create_new_item
  end

  private

  def update_quantity_and_return_item
    @order_item.update(quantity: @order_item.quantity + @params[:quantity].to_i)
    @order_item
  end

  def create_new_item
    @order.order_items.new(@params)
  end
end
