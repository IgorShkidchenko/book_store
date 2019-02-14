class Order < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :order_status
  belongs_to :delivery_method, optional: true

  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items
  has_one :coupon
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :credit_card, dependent: :destroy
end
