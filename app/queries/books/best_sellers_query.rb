class Books::BestSellersQuery
  BEST_SELLERS_QUANTITY = 4

  class << self
    def call
      best_sellers_ids = Book.find_by_sql(best_sellers_ids_sql_query).map(&:book_id)
      Book.where(id: best_sellers_ids).includes(:authors, :covers)
    end

    private

    def best_sellers_ids_sql_query
      ["
      SELECT book_id FROM (
        SELECT (array_agg(books.id ORDER BY order_items.quantity DESC))[1] AS book_id, books.category_id
        FROM books
        LEFT JOIN order_items ON order_items.book_id = books.id
        LEFT JOIN orders ON orders.id = order_items.order_id
        WHERE orders.aasm_state = ?
        GROUP BY books.category_id
        LIMIT ?
      ) AS book_ids
      ",Order.aasm_states[:delivered], BEST_SELLERS_QUANTITY]
    end
  end
end
