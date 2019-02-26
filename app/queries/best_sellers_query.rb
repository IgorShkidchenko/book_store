class BestSellersQuery
  def self.call
    Category.all.size.times.map do |index|
      Book.where(category_id: index + 1).joins(:order_items).group(:id).order('count(order_items.id) desc').first
    end
  end
end
