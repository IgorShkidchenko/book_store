class Filter
  VALID_FILTERS = {
    title_asc: 'title',
    title_desc: 'title desc',
    price_asc: 'price',
    price_desc: 'price desc',
    newest: 'created_at'
  }.freeze

  def initialize(params, books)
    @params = params
    @books = books
  end

  def call
    @books.order(choose_filter).includes(:authors)
  end

  private

  def choose_filter
    @params[:filter] if VALID_FILTERS.value? @params[:filter]
  end
end
