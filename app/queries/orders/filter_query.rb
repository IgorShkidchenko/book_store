class Orders::FilterQuery < ApplicationQuery
  def initialize(user:, params:)
    @filter = params[:filter]
    @user = user
  end

  def call
    filter_valid? ? filtred_orders : all_processing_orders_of_user
  end

  private

  def filter_valid?
    processing_statuses.include?(@filter)
  end

  def all_processing_orders_of_user
    @user.orders.includes(:coupon, :delivery_method, order_items: :book).where(aasm_state: processing_statuses)
  end

  def filtred_orders
    @user.orders.includes(:coupon, :delivery_method, order_items: :book).where(aasm_state: @filter)
  end

  def processing_statuses
    Order.aasm_states.keys.last(5)
  end
end
