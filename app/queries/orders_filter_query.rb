class OrdersFilterQuery
  def initialize(user:, params:)
    @filter = params[:filter]
    @user = user
  end

  def call
    filter_valid? ? filtred_orders : all_user_orders
  end

  private

  def filter_valid?
    Order::PROCESSING_STATUSES.value?(@filter)
  end

  def all_user_orders
    @user.orders.where.not(aasm_state: Order::CHECKOUT_STATUSES).includes(:coupon, :delivery_method)
  end

  def filtred_orders
    @user.orders.where(aasm_state: @filter).includes(:coupon, :delivery_method)
  end
end
