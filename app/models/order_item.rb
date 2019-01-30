class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :order_present

  private

  def order_present
    errors.add(:order, I18n.t('order_item.error')) if order.nil?
  end
end
