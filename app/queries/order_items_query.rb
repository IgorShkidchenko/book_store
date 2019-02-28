class OrderItemsQuery
  LATEST = 'created_at desc'.freeze

  def initialize(order)
    @order = order
  end

  def call
    @order.order_items.order(LATEST).includes(book: :covers)
  end
end
