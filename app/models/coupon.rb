class Coupon < ApplicationRecord
  belongs_to :order, optional: true

  scope :was_used, -> { Coupon.where(used: true) }
  scope :unused, -> { Coupon.where(used: false) }
end
