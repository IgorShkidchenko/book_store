class Paginators::BooksService
  def initialize(category:, params:)
    @category = category
    @params = params
  end

  def call
    BooksFilterQuery.new(books: chosen_books, params: @params).call
  end

  private

  def chosen_books
    which_books_to_shown.includes(:covers)
  end

  def which_books_to_shown
    @category ? @category.books : Book.all
  end
end
