class Address < ApplicationRecord
  TYPES = {
    billing: 'billing',
    shipping: 'shipping'
  }.freeze

  belongs_to :addressable, polymorphic: true

  scope :billing, -> { where(kind: TYPES[:billing]) }
  scope :shipping, -> { where(kind: TYPES[:shipping]) }
end
