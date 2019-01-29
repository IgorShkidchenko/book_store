class HomeController < ApplicationController
  LATEST_THREE_QUANTITY = 3

  decorates_assigned :latest_three, :best_sellers

  def index
    @latest_three = Book.limit(LATEST_THREE_QUANTITY).order('id desc').includes(:authors, :covers)
    @best_sellers = Book.limit(4).includes(:authors, :covers) # for now
  end
end
