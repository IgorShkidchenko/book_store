class Orders::OrderItemsQuery < ApplicationQuery
  def initialize(order)
    @order = order
  end

  def call
    @order.order_items.includes(book: :covers).order(created_at: :desc)
  end
end
