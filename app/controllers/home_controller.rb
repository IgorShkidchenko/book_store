class HomeController < ApplicationController
  include Rectify::ControllerHelpers

  LATEST_THREE_QUANTITY = 3

  decorates_assigned :latest_three, :best_sellers

  def index
    @latest_three = Book.limit(LATEST_THREE_QUANTITY).order('id desc').includes(:authors, :covers)
    @best_sellers = Book.limit(4).includes(:authors, :covers) # for now
    @representers_for_best_sellers = @best_sellers.map { |book| present BookPresenter.new(book: book) }
    @representers_for_latest_three = @latest_three.map { |book| present BookPresenter.new(book: book) }
  end
end
