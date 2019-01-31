class Coupon < ApplicationRecord
  belongs_to :order, optional: true

  scope :unused, -> { where(order_id: nil) }
  scope :used, -> { where('order_id is not null') }
end
