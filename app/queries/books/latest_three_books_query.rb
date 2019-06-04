class Books::LatestThreeBooksQuery
  LATEST_THREE_BOOK_QUANTITY = 3

  def self.call
    Book.includes(:authors, :covers).order(created_at: :desc).limit(LATEST_THREE_BOOK_QUANTITY)
  end
end
