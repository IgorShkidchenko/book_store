class CategoriesController < ApplicationController
  include Rectify::ControllerHelpers
  include Pagy::Backend

  decorates_assigned :chosen_books

  def index
    @books = Book.all
    @category = Category.find(params[:category_id]) if params[:category_id]
    @pagy, @chosen_books = pagy(Filter.new(params, which_books_to_shown).call, items: 12)
    @representers_for_chosen_books = @chosen_books.map { |book| present BookPresenter.new(book: book) }
  end

  private

  def which_books_to_shown
    (@category&.books || @books).includes(:covers)
  end
end
