ActiveAdmin.register Coupon do
  permit_params :key

  actions :index, :show, :create
  includes :order

  scope :unused, default: true
  scope :was_used
  scope :all

  config.filters = false

  action_item :generate_coupon, only: :index do
    link_to t('admin.coupon.generate'),
            admin_coupons_path(coupon: { key: Coupons::KeyGeneratorService.call }),
            method: :post
  end

  index do
    render 'admin/coupons/index', context: self
  end
end
