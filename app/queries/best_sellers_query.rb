class BestSellersQuery
  def self.call
    Category.all.map do |category|
      category.books.joins(:order_items).group(:id).order('count(order_items.id) desc').first
    end
  end
end
