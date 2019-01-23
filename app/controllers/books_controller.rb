class BooksController < ApplicationController
  before_action :set_cookies, only: :show

  def show
    @book = Book.friendly.find(params[:id])
  end
end
