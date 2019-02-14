class DeliveryMethod < ApplicationRecord
  has_many :orders
end
