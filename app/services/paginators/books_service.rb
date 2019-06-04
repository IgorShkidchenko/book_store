class Paginators::BooksService < ApplicationService
  def initialize(category:, params:)
    @category = category
    @params = params
  end

  def call
    Books::FilterQuery.call(books: which_books_to_shown, params: @params)
  end

  private

  def which_books_to_shown
    @category ? @category.books : Book.all
  end
end
