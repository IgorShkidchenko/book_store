class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :order_present

  def update_total_price
    update(total_price: quantity * book.price)
  end

  def update_quantity(params_quantity)
    update(quantity: quantity + params_quantity)
  end

  private

  def order_present
    errors.add(:order, 'is not a valid order.') if order.nil?
  end
end
