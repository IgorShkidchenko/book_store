class Books::BestSellersQuery
  BEST_SELLERS_QUANTITY = 4

  class << self
    def call
      Book.find_by_sql(best_sellers_sql_query)
    end

    private

    def best_sellers_sql_query
      <<-SQL
      SELECT *
      FROM books
      WHERE id IN (
        SELECT book_id FROM (
          SELECT DISTINCT ON(category_id) category_id, book_id, total
          FROM (
            SELECT order_items.book_id, SUM(order_items.quantity) AS total, books.category_id
            FROM order_items
            LEFT JOIN books ON order_items.book_id = books.id
            LEFT JOIN orders ON orders.id = order_items.order_id
            WHERE orders.aasm_state = #{Order.aasm_states[:delivered]}
            GROUP BY order_items.book_id, books.category_id
            ORDER BY total DESC
          ) AS sub_query
          ORDER BY category_id, total DESC
          LIMIT #{BEST_SELLERS_QUANTITY}
        ) AS books
      );
      SQL
    end
  end
end
