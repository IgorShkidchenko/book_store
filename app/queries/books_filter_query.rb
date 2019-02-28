class BooksFilterQuery
  VALID_FILTERS = {
    title_asc: 'title',
    title_desc: 'title desc',
    price_asc: 'price',
    price_desc: 'price desc',
    newest: 'created_at',
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
    @books.joins(:order_items).group(:id).order('count(order_items.id) desc')
  end

  def simple_ordered_books
    @books.order(chosen_filter).includes(:authors)
  end

  def chosen_filter
    @filter if VALID_FILTERS.value?(@filter)
  end
end
