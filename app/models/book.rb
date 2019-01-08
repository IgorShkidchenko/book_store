class Book < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  mount_uploader :cover, CoverUploader

  belongs_to :category
  has_many :book_authors
  has_many :authors, through: :book_authors

  def authors_as_string
    authors.map(&:name).join(', ')
  end

  def self.latest_three
    Book.last(3)
  end
end
