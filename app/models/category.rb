class Category < ApplicationRecord
  VALID_FILTERS = {
    title: 'title',
    title_desc: 'title desc',
    price: 'price',
    price_desc: 'price desc',
    newest: 'created_at'
  }.freeze

  has_many :books
end
