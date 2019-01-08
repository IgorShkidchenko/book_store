class CategoriesController < ApplicationController
  include Pagy::Backend

  VALID_FILTERS = %W[title title\ desc price price\ desc created_at].freeze

  def index
    set_page_variables
    @pagy, @chosen_books = pagy((@category&.books || @books).order(validate_filter).includes(:authors), items: 12)
  end

  private

  def validate_filter
    params[:filter] if VALID_FILTERS.include? params[:filter]
  end

  def set_page_variables
    @books = Book.all
    @category = Category.find_by_id(params[:category_id]) if params[:category_id]
  end
end
