class Books::BestSellersQuery
  BEST_SELLERS_QUANTITY = 4

  class << self
    def call
      ids = Book.find_by_sql(best_sellers_ids_sql_query).map(&:book_id)
      Book.where(id: ids).includes(:authors, :covers)
    end

    private

    def best_sellers_ids_sql_query
      <<-SQL
        SELECT book_id FROM (
          SELECT (array_agg(books.id ORDER BY order_items.quantity DESC))[1] AS book_id, books.category_id
          FROM books
          LEFT JOIN order_items ON order_items.book_id = books.id
          LEFT JOIN orders ON orders.id = order_items.order_id
          WHERE orders.aasm_state = #{Order.aasm_states['delivered']}
          GROUP BY books.category_id
          LIMIT #{BEST_SELLERS_QUANTITY}
        ) AS book_ids
      SQL
    end
  end
end
