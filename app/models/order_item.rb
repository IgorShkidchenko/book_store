class OrderItem < ActiveRecord::Base
  MINIMUN_QUANTITY = 0

  belongs_to :book
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: MINIMUN_QUANTITY }

  delegate :price, :title, to: :book, prefix: true
end
