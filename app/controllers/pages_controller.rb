class PagesController < ApplicationController
  LATEST_THREE_QUANTITY = 3
  BEST_SELLERS_QUANTITY = 4

  decorates_assigned :latest_three, :best_sellers

  def home
    @latest_three = Book.limit(LATEST_THREE_QUANTITY).order('id desc').includes(:authors, :covers)
    @best_sellers = Book.limit(BEST_SELLERS_QUANTITY).includes(:authors, :covers) # TEST FOR VIEW
  end
end
