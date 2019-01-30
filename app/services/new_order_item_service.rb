class NewOrderItemService
  def initialize(params, order)
    @params = params
    @order = order
  end

  def call
    @order_item = @order.order_items.find_by_book_id(@params[:book_id])
    @order_item ? update_quantity : create_new_item
  end

  private

  def update_quantity
    @order_item.update(quantity: @order_item.quantity + @params[:quantity].to_i)
    @order_item
  end

  def create_new_item
    @order.order_items.new(@params)
  end
end
