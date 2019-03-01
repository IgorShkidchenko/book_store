class Address < ApplicationRecord
  KINDS = {
    billing: 'billing',
    shipping: 'shipping'
  }.freeze

  belongs_to :addressable, polymorphic: true

  scope :billing, -> { where(kind: KINDS[:billing]) }
  scope :shipping, -> { where(kind: KINDS[:shipping]) }
end
