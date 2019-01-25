class BooksController < ApplicationController
  include Rectify::ControllerHelpers
  include BackUrl

  decorates_assigned :book

  def show
    set_cookies
    @book = Book.friendly.find(params[:id])
    present BookPresenter.new(book: @book)
  end
end
