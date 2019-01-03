class Book < ApplicationRecord
  belongs_to :category
  has_many :book_authors
  has_many :authors, through: :book_authors
end
