class OrderItems::NewCartItemService < ApplicationService
  def initialize(params:, order:)
    @params = params
    @order = order
    @order_item = @order.order_items.find_by(book_id: @params[:book_id])
  end

  def call
    @order_item ? update_quantity : create_new_item
  end

  private

  def update_quantity
    @order_item.update(quantity: new_calculated_quantity)
  end

  def new_calculated_quantity
    @order_item.quantity + @params[:quantity].to_i
  end

  def create_new_item
    @order.save unless @order.persisted?
    @order.order_items.create(@params)
  end
end
