class PagesController < ApplicationController
  decorates_assigned :latest_three, :best_sellers

  def home
    @latest_three = Books::LatestThreeQuery.call
    @best_sellers = Books::BestSellersQuery.call
  end
end
