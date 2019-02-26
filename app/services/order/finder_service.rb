class Order::FinderService
  def initialize(order_id, user)
    @order_id = order_id
    @user = user
  end

  def call
    return Order.find_by(id: @order_id) if order_valid?

    Order.new(user_id: @user&.id)
  end

  private

  def order_valid?
    @order_id && !Order.find_by(id: @order_id).may_canceled?
  end
end
