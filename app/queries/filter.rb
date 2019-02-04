class Filter
  VALID_FILTERS = {
    title_asc: 'title',
    title_desc: 'title desc',
    price_asc: 'price',
    price_desc: 'price desc',
    newest: 'created_at'
  }.freeze

  def initialize(params, books)
    @filter = params[:filter]
    @books = books
  end

  def call
    @books.order(chosen_filter).includes(:authors)
  end

  private

  def chosen_filter
    @filter if VALID_FILTERS.value?(@filter)
  end
end
