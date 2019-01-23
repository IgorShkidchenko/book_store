class HomeController < ApplicationController
  decorates_assigned :latest_three, :best_sellers

  def index
    @latest_three = Book.latest_three
    @best_sellers = Book.best_sellers
  end
end
