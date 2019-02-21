class BooksController < ApplicationController
  BOOKS_ON_PAGE_QUANTITY = 12

  include BackUrl
  include Pagy::Backend
  include BooksHelper
  decorates_assigned :book, :chosen_books

  def index
    @categories = Category.all
    @category = Category.find_by(id: params[:category_id])
    @pagy, @chosen_books = pagy(Filter.new(params, which_books_to_shown).call, items: BOOKS_ON_PAGE_QUANTITY)
  end

  def show
    set_cookies_for_back_url
    @book = Book.friendly.find(params[:id])
  end

  private

  def which_books_to_shown
    (@category ? @category.books : Book.all).includes(:covers)
  end
end
