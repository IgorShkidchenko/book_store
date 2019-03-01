class Users::SessionsController < Devise::SessionsController
  include BackUrl
  before_action :set_cookies_for_back_url, only: %i[new create]

  def create
    self.resource = warden.authenticate!(auth_options)
    successful_sign_in
    return redirect_to checkout_step_path(:address) if params[:user][:checkout_authenticate]

    respond_with resource, location: after_sign_in_path_for(resource)
  end

  private

  def successful_sign_in
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    insert_order_to_user if user_have_not_current_order?
  end

  def insert_order_to_user
    current_order.update(user_id: resource.id)
  end

  def user_have_not_current_order?
    session[:order_id] && !Order.find_by(user_id: resource.id)
  end
end
