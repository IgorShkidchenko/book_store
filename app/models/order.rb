class Order < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :order_status

  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items

  def update_total_price
    update(total_price: order_items.includes(:book).map(&:total_price).sum)
  end
end
