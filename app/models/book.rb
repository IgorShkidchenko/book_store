class Book < ApplicationRecord
  VALID_FILTERS = {
    title: 'title',
    title_desc: 'title desc',
    price: 'price',
    price_desc: 'price desc',
    newest: 'created_at'
  }.freeze

  extend FriendlyId
  friendly_id :title, use: :slugged

  mount_uploader :cover, CoverUploader

  belongs_to :category
  has_many :book_authors
  has_many :authors, through: :book_authors, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates_presence_of :title

  scope :filtred, ->(filter) { order(filter).includes(:authors) }

  def authors_as_string
    authors.map(&:name).join(', ')
  end

  def self.latest_three
    Book.limit(3).order('id desc').includes(:authors)
  end
end
