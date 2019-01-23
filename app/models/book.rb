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
  scope :latest_three, -> { limit(3).order('id desc').includes(:authors) }
  scope :best_sellers, -> { limit(4).includes(:authors) } # TEST / A grade view of 4 books, that was sold more than all others in -- EACH CATEGORY --
end
