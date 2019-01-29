class CategoriesController < ApplicationController
  include Pagy::Backend

  decorates_assigned :chosen_books

  def index
    @books = Book.all
    @category = Category.find(params[:category_id]) if params[:category_id]
    @pagy, @chosen_books = pagy(Filter.new(params, which_books_to_shown).call, items: 12)
  end

  private

  def which_books_to_shown
    (@category&.books || @books).includes(:covers)
  end
end
