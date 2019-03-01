class BooksController < ApplicationController
  include Rectify::ControllerHelpers
  include BackUrl
  include Pagy::Backend
  include BooksHelper
  decorates_assigned :book, :chosen_books

  def index
    @categories = Category.all
    @category = Category.find_by(id: params[:category_id])
    @pagy, @chosen_books = pagy(which_books_to_shown)
    present CatalogPresenter.new(params: params, category: @category, categories: @categories)
  end

  def show
    set_cookies_for_back_url
    @book = Book.friendly.find(params[:id])
  end

  private

  def which_books_to_shown
    books = (@category ? @category.books : Book.all).includes(:covers)
    BooksFilterQuery.new(books: books, params: params).call
  end
end
