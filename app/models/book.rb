class Book < ApplicationRecord
  VALID_FILTERS = {
    title: 'title',
    title_desc: 'title desc',
    price: 'price',
    price_desc: 'price desc',
    newest: 'created_at'
  }.freeze
  MAXIMUM_COVERS_QUANTITY = 4

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category
  has_many :book_authors
  has_many :authors, through: :book_authors, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :covers, dependent: :destroy

  accepts_nested_attributes_for :covers, allow_destroy: true

  validates_presence_of :title
  validate :validate_covers_quantity

  def validate_covers_quantity
    errors.add(:covers, I18n.t('book.covers_max_error', max: MAXIMUM_COVERS_QUANTITY)) if covers.size > MAXIMUM_COVERS_QUANTITY
  end

  scope :filtred, ->(filter) { order(filter).includes(:authors) }
  scope :latest_three, -> { limit(3).order('id desc').includes(:authors) }
  scope :best_sellers, -> { limit(4).includes(:authors) } # TEST / A grade view of 4 books, that was sold more than all others in -- EACH CATEGORY --
end
