class PagesController < ApplicationController
  decorates_assigned :latest_three_book, :best_sellers

  def home
    @latest_three_book = Books::LatestThreeBooksQuery.call
    @best_sellers = Books::BestSellersQuery.call
  end
end
