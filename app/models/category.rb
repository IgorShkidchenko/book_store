class Category < ApplicationRecord
  has_many :books, dependent: :destroy

  validates_presence_of :name

  def books_quantity
    books.count
  end
end
