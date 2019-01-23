class ApplicationController < ActionController::Base
  METHOD_GET = 'GET'.freeze

  before_action :set_header_variables

  def set_cookies
    return @back = cookies[:back_url] if back_url_invalid?

    cookies[:back_url] = request.referer
    @back = cookies[:back_url]
  end

  def back_url_invalid?
    request.referer.nil? || request.method != METHOD_GET || request.referer == request.url
  end

  private

  def set_header_variables
    @categories = Category.all
  end
end
