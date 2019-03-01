class ApplicationController < ActionController::Base
  before_action :set_header_presenter
  protect_from_forgery with: :exception
  helper_method :current_order

  private

  def set_header_presenter
    @header_presenter = HeaderPresenter.new.attach_controller(self)
  end

  def current_order
    Orders::FinderService.new(session[:order_id], current_user).call
  end
end
