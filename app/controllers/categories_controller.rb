class CategoriesController < ApplicationController
  decorates_assigned :chosen_books
  include Pagy::Backend

  def index
    @books = Book.all
    @category = Category.find(params[:category_id]) if params[:category_id]
    @pagy, @chosen_books = pagy(which_books_to_shown.filtred(validate_filter), items: 12)
  end

  private

  def validate_filter
    params[:filter] if Book::VALID_FILTERS.value? params[:filter]
  end

  def which_books_to_shown
    @category&.books || @books
  end
end
