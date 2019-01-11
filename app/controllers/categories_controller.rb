class CategoriesController < ApplicationController
  include Pagy::Backend

  def index
    set_page_variables
    @pagy, @chosen_books = pagy((@category&.books || @books).order(validate_filter).includes(:authors), items: 12)
  end

  private

  def validate_filter
    params[:filter] if Category::VALID_FILTERS.value? params[:filter]
  end

  def set_page_variables
    @books = Book.all
    @category = Category.find_by_id(params[:category_id]) if params[:category_id]
  end
end
