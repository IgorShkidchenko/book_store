class OrderStatus < ApplicationRecord
  STATUSES = {
    in_progress: 'in_progress',
    in_queue: 'in_queue',
    in_delivery: 'in_delivery',
    delivered: 'delivered',
    canceled: 'canceled'
  }.freeze

  has_many :orders
end
