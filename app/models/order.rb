class Order < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :order_status
  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items
  has_one :coupon

  delegate :discount, to: :coupon, prefix: true
end
