class OrderItemDecorator < Draper::Decorator
  delegate_all
  delegate :price, :title, to: :book, prefix: true
end
