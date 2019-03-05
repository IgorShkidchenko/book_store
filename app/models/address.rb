class Address < ApplicationRecord
  KINDS = {
    billing: 0,
    shipping: 1
  }.freeze

  belongs_to :addressable, polymorphic: true

  enum kind: { billing: KINDS[:billing], shipping: KINDS[:shipping] }
end
