class Book < ApplicationRecord
  LATEST_THREE_QUANTITY = 3
  BEST_SELLERS_QUANTITY = 4

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category, counter_cache: true

  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :reviews, dependent: :destroy
  has_many :covers, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  accepts_nested_attributes_for :covers, allow_destroy: true

  validates :title, presence: true
  validates :covers, covers_quantity: true

  scope :latest_three, -> { limit(LATEST_THREE_QUANTITY).order('created_at desc').includes(:authors, :covers) }
end
