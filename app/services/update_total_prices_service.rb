class UpdateTotalPricesService
  def initialize(order_item: nil, order:)
    @order_item = order_item
    @order = order
  end

  def call
    update_order_item_total_price if @order_item
    calculate_new_order_subtotal_price
    update_order_total_price
  end

  private

  def update_order_item_total_price
    @order_item.update(total_price: @order_item.quantity * @order_item.book_price)
  end

  def calculate_new_order_subtotal_price
    @new_subtotal = @order.order_items.sum(&:total_price)
  end

  def update_order_total_price
    @order.update(subtotal_price: @new_subtotal, total_price: calculated_total_price)
  end

  def calculated_total_price
    @new_subtotal - coupon_amount + delivery_method_amount
  end

  def coupon_amount
    @order.coupon&.discount || 0
  end

  def delivery_method_amount
    @order.delivery_method&.cost || 0
  end
end
