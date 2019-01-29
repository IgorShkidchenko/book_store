class BooksController < ApplicationController
  include BackUrl

  decorates_assigned :book

  def show
    set_cookies
    @book = Book.friendly.find(params[:id])
  end
end
