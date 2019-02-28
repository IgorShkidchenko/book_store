class OrdersFilterQuery
  CHECKOUT_STATUSES = %w[new fill_delivery fill_payment editing].freeze
  VALID_FILTERS = %w[in_queue in_delivery delivered canceled].freeze

  def initialize(user:, params:)
    @filter = params[:filter]
    @user = user
  end

  def call
    filter_valid? ? filtred_orders : all_user_orders
  end

  private

  def filter_valid?
    VALID_FILTERS.include? @filter
  end

  def all_user_orders
    @user.orders.where.not(aasm_state: CHECKOUT_STATUSES).includes(:coupon, :delivery_method)
  end

  def filtred_orders
    @user.orders.where(aasm_state: @filter).includes(:coupon, :delivery_method)
  end
end
