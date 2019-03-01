class OrderItemDecorator < Draper::Decorator
  MINIMUM_QUANTITY = 1

  delegate_all

  def minus_quantity_link
    css_class = "input-link #{'disable_minus' if order_item.quantity == MINIMUM_QUANTITY}"
    h.link_to h.order_item_path(order_item, order_item: { command: nil }), remote: true, method: :put,
                                                                           class: css_class do
      h.content_tag(:i, '', class: 'fa fa-minus line-heaght-40')
    end
  end

  def plus_quantity_link
    h.link_to h.order_item_path(order_item, order_item: { command: OrderItem::QuantityUpdaterService::ADD }),
              remote: true, method: :put, class: 'input-link' do
      h.content_tag(:i, '', class: 'fa fa-plus line-heaght-40')
    end
  end

  def total_price
    I18n.t('price', price: (quantity * book_price).round(2))
  end
end
