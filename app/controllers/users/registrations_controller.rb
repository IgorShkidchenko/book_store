class Users::RegistrationsController < Devise::RegistrationsController
  include BackUrl
  before_action :set_cookies_for_back_url, only: %i[new create]

  def create
    return checkout_authenticate if params[:user][:checkout_authenticate]

    super
    set_order_to_user
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
    if resource.save
      authenticate_user(resource_name, resource)
      redirect_to checkout_step_path(:address)
    else
      flash[:danger] = resource.errors.full_messages.to_sentence
      redirect_to checkout_step_path(:quick_authenticate)
    end
  end

  def authenticate_user(resource_name, resource)
    sign_up(resource_name, resource)
    set_order_to_user
    resource_class.send_reset_password_instructions(resource_params)
  end

  def set_order_to_user
    current_order.update(user_id: resource.id) if session[:order_id]
  end

  def find_user_addresses
    @billing = AddressForm.new(resource.addresses.billing.first&.attributes)
    @shipping = AddressForm.new(resource.addresses.shipping.first&.attributes)
  end
end
