class ApplicationController < ActionController::Base
  before_action :set_header_presenter
  protect_from_forgery with: :exception
  helper_method :current_order

  private

  def set_header_presenter
    @header_presenter = HeaderPresenter.new.attach_controller(self)
  end

  def current_order
    Order::FinderService.new(session[:order_id], current_user).call
  end
end

# TODO: user edit page
# TODO: send email to user
# TODO: orders active admin
# TODO: devise no password
# TODO: enum
# TODO: cancancan
# TODO: aws
# TODO: english
# TODO: tests
# TODO: orders merge
