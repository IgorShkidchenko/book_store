class BooksFilterQuery
  VALID_FILTERS = {
    title_asc: 'title asc',
    title_desc: 'title desc',
    price_asc: 'price asc',
    price_desc: 'price desc',
    created_at: 'created_at',
    popular: 'popular'
  }.freeze

  def initialize(books:, params:)
    @filter = params[:filter]
    @books = books
  end

  def call
    @filter == VALID_FILTERS[:popular] ? popular_books : simple_ordered_books
  end

  private

  def popular_books
    @books.joins(:order_items).group(:id).order(BestSellersQuery::COUNT_BY_ITEMS_ID_DESC).includes(:authors)
  end

  def simple_ordered_books
    @books.order(chosen_filter).includes(:authors)
  end

  def chosen_filter
    @filter if VALID_FILTERS.value?(@filter)
  end
end
