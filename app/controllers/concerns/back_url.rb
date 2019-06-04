module BackUrl
  extend ActiveSupport::Concern

  METHOD_GET = 'GET'.freeze

  included do
    def set_cookies_for_back_url
      @referer = request.referer
      return @back = cookies[:back_url] unless back_url_valid?

      cookies[:back_url] = @referer
      @back = @referer
    end

    private

    def back_url_valid?
      [back_path_present?, current_method_get?, page_was_not_refreshed?].all?
    end

    def back_path_present?
      @referer
    end

    def current_method_get?
      request.method.eql?(METHOD_GET)
    end

    def page_was_not_refreshed?
      @referer != request.url
    end
  end
end
