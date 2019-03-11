ActiveAdmin.register Order do
  decorate_with OrderDecorator

  actions :index, :show

  includes :coupon, :delivery_method, order_items: :book

  scope :in_progress, default: true
  scope :in_queue
  scope :in_delivery
  scope :delivered
  scope :canceled

  config.filters = false

  batch_action I18n.t('admin.batches.in_queue'), if: proc { @current_scope.scope_method == :in_progress } do |ids|
    orders = Order.in_progress.where(id: ids)
    orders.any? ? orders.each(&:in_queue!) : flash[:danger] = I18n.t('admin.error.not_found')
    redirect_to(admin_orders_path)
  end

  batch_action I18n.t('admin.batches.in_delivery'), if: proc { @current_scope.scope_method == :in_queue } do |ids|
    orders = Order.in_queue.where(id: ids)
    orders.any? ? orders.each(&:in_delivery!) : flash[:danger] = I18n.t('admin.error.not_found')
    redirect_to(admin_orders_path)
  end

  batch_action I18n.t('admin.batches.delivered'), if: proc { @current_scope.scope_method == :in_delivery } do |ids|
    orders = Order.in_delivery.where(id: ids)
    orders.any? ? orders.each(&:delivered!) : flash[:danger] = I18n.t('admin.error.not_found')
    redirect_to(admin_orders_path)
  end

  batch_action I18n.t('admin.batches.canceled'), if: proc { @current_scope.scope_method != :canceled } do |ids|
    orders = Order.where(id: ids)
    orders.any? ? orders.each(&:canceled!) : flash[:danger] = I18n.t('admin.error.not_found')
    redirect_to(admin_orders_path)
  end

  index do
    render 'admin/orders/index', context: self
  end
end
