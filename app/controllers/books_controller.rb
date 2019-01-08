class BooksController < ApplicationController
  def show
    @book = Book.friendly.find(params[:id])
  end
end
