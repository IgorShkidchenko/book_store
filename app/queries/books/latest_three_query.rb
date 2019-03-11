class Books::LatestThreeQuery
  LATEST_THREE_QUANTITY = 3

  def self.call
    Book.includes(:authors, :covers).order(created_at: :desc).limit(LATEST_THREE_QUANTITY)
  end
end
