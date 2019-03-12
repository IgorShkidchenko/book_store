class Users::RegistrationsController < Devise::RegistrationsController
  include BackUrl
  before_action :set_cookies_for_back_url, only: %i[new create]

  def create
    return checkout_authenticate if params.dig(:user, :checkout_authenticate)

    super
    set_order_to_user if session[:order_id]
  end

  def edit
    find_user_addresses
  end

  def update
    find_user_addresses
    super
  end

  private

  def checkout_authenticate
    build_resource(sign_up_params)
    resource.skip_confirmation!
    if resource.save
      authenticate_user
      redirect_to checkout_step_path(CheckoutStepsController::STEPS[:address])
    else
      flash[:danger] = resource.errors.full_messages.to_sentence
      redirect_to checkout_step_path(CheckoutStepsController::STEPS[:authenticate])
    end
  end

  def authenticate_user
    sign_up(resource_name, resource)
    set_order_to_user if session[:order_id]
    resource_class.send_reset_password_instructions(resource_params)
  end

  def set_order_to_user
    current_order.update(user: resource)
  end

  def find_user_addresses
    addresses_of_user = resource.addresses
    @billing = AddressForm.new(addresses_of_user.billing.first&.attributes)
    @shipping = AddressForm.new(addresses_of_user.shipping.first&.attributes)
  end

  protected

  def update_resource(resource, params)
    return resource.update_without_password(params) unless params[:current_password]

    super
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
