class CategoriesController < ApplicationController
  def index
    @all_books = Book.all
    params[:category_id] ? set_books_with_category : set_all_books
    set_filter if params[:filter]
    paginate_chosen_books
  end

  private

  def set_all_books
    @chosen_books = @all_books
  end

  def set_books_with_category
    @category = Category.find_by_id(params[:category_id])
    @chosen_books = @category.books
  end

  def set_filter
    @chosen_books = @chosen_books.sort_by(&params[:filter].to_sym)
    @chosen_books.reverse! if params[:reverse]
  end

  def paginate_chosen_books
    @chosen_books = Kaminari.paginate_array(@chosen_books).page(params[:page]).per(12)
  end
end
