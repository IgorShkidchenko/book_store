class BooksController < ApplicationController
  def show
    @book = Book.find_by_id(params[:book_id])
  end
end
