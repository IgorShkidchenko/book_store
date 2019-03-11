class Books::FilterQuery < ApplicationQuery
  COUNT_BY_ITEMS_ID_DESC = 'count(order_items.id) desc'.freeze
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
    @books.includes(:authors, :covers).joins(:order_items).group(:id).order(COUNT_BY_ITEMS_ID_DESC)
  end

  def simple_ordered_books
    @books.includes(:authors, :covers).order(chosen_filter)
  end

  def chosen_filter
    @filter if VALID_FILTERS.value?(@filter)
  end
end
