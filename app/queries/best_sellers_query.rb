class BestSellersQuery
  COUNT_BY_ITEMS_ID_DESC = 'count(order_items.id) desc'.freeze

  def self.call
    Category.all.map do |category|
      category.books.joins(:order_items)
              .group(:id)
              .order(COUNT_BY_ITEMS_ID_DESC).first
    end
  end
end
