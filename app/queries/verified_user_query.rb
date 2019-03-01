class VerifiedUserQuery
  def initialize(book, user)
    @book = book
    @user = user
  end

  def call
    Order.where(user_id: @user.id, aasm_state: Order::PROCESSING_STATUSES[:delivered])
         .joins(:order_items)
         .select(:book_id)
         .group(:book_id)
         .having("book_id = #{@book.id}")
  end
end
