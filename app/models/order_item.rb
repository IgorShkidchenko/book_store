class OrderItem < ActiveRecord::Base
  MINIMUN_QUANTITY = 0

  belongs_to :book
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: MINIMUN_QUANTITY }
  validate :order_present

  delegate :price, :title, to: :book, prefix: true

  private

  def order_present
    errors.add(:order, I18n.t('order_item.error')) unless order
  end
end
