ActiveAdmin.register Order do
  actions :index, :show

  includes :coupon, :delivery_method

  scope :in_progress, default: true
  scope :in_queue
  scope :in_delivery
  scope :delivered
  scope :canceled

  config.filters = false
  config.per_page = [10, 50, 100]

  batch_action :in_queue, if: proc { @current_scope.scope_method == :in_progress } do |ids|
    Order.in_progress.find(ids).each(&:in_queue!)
    redirect_to admin_orders_path
  end

  batch_action :in_delivery, if: proc { @current_scope.scope_method == :in_queue } do |ids|
    Order.in_queue.find(ids).each(&:in_delivery!)
    redirect_to admin_orders_path
  end

  batch_action :delivered, if: proc { @current_scope.scope_method == :in_delivery } do |ids|
    Order.in_delivery.find(ids).each(&:delivered!)
    redirect_to admin_orders_path
  end

  batch_action :canceled, if: proc { @current_scope.scope_method != :canceled } do |ids|
    Order.find(ids).each(&:canceled!)
    redirect_to admin_orders_path
  end

  index do
    render 'admin/orders/index', context: self
  end
end
