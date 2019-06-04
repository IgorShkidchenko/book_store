class Orders::FinderService < ApplicationService
  def initialize(order_id, user)
    @order = Order.find_by(id: order_id)
    @user = user
  end

  def call
    order_in_progress? ? @order : Order.new(user: @user)
  end

  private

  def order_in_progress?
    @order && order_in_checkout_state?
  end

  def order_in_checkout_state?
    @order.may_canceled?.eql?(false)
  end
end
