class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_header_presenter
  helper_method :current_order

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, flash: { danger: I18n.t('cancan.error') }
  end

  private

  def current_order
    @current_order ||= Orders::FinderService.call(session[:order_id], current_user).decorate
  end

  def set_header_presenter
    @header_presenter = HeaderPresenter.new.attach_controller(self)
  end
end
