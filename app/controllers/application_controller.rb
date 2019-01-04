class ApplicationController < ActionController::Base
  before_action :set_header_variables

  private

  def set_header_variables
    @categories = Category.all
  end
end
