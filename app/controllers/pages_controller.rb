class PagesController < ApplicationController
  decorates_assigned :latest_three, :best_sellers

  def home
    @latest_three = Book.latest_three
    @best_sellers = BestSellersQuery.call
  end
end
