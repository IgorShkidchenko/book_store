class BooksController < ApplicationController
  include Rectify::ControllerHelpers
  include Pagy::Backend
  include BackUrl
  include BooksHelper

  load_resource only: :show
  load_resource :category, only: :index
  authorize_resource
  decorates_assigned :book, :chosen_books

  def index
    @categories = Category.all
    @pagy, @chosen_books = pagy Paginators::BooksService.new(params: params, category: @category).call
    present CatalogPresenter.new(params: params, category: @category, categories: @categories)
  end

  def show
    set_cookies_for_back_url
  end
end
