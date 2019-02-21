module BackUrl
  extend ActiveSupport::Concern

  METHOD_GET = 'GET'.freeze

  included do
    def set_cookies_for_back_url
      @referer = request.referer
      return @back = cookies[:back_url] if back_url_invalid?

      cookies[:back_url] = @referer
      @back = @referer
    end

    private

    def back_url_invalid?
      !@referer || not_method_get? || page_was_refreshed?
    end

    def not_method_get?
      request.method != METHOD_GET
    end

    def page_was_refreshed?
      @referer == request.url
    end
  end
end
