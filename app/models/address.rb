class Address < ApplicationRecord
  TYPES = {
    billing: 'billing',
    shipping: 'shipping'
  }.freeze

  belongs_to :addressable, polymorphic: true

  scope :billing, -> { find_by(kind: TYPES[:billing]) }
  scope :shipping, -> { find_by(kind: TYPES[:shipping]) }
end
