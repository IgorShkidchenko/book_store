module BackUrl
  extend ActiveSupport::Concern

  METHOD_GET = 'GET'.freeze

  included do
    def set_cookies
      return @back = cookies[:back_url] if back_url_invalid?

      cookies[:back_url] = request.referer
      @back = cookies[:back_url]
    end

    private

    def back_url_invalid?
      request.referer.nil? || request.method != METHOD_GET || request.referer == request.url
    end
  end
end
