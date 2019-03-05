class Users::RegistrationsController < Devise::RegistrationsController
  include BackUrl
  before_action :set_cookies_for_back_url, only: %i[new create]

  def create
    return checkout_authenticate if params[:user][:checkout_authenticate]

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
      redirect_to checkout_step_path(:address)
    else
      flash[:danger] = resource.errors.full_messages.to_sentence
      redirect_to checkout_step_path(:quick_authenticate)
    end
  end

  def authenticate_user
    sign_up(resource_name, resource)
    set_order_to_user if session[:order_id]
    resource_class.send_reset_password_instructions(resource_params)
  end

  def set_order_to_user
    current_order.update(user_id: resource.id)
  end

  def find_user_addresses
    user_addresses = resource.addresses
    @billing = AddressForm.new(user_addresses.billing.first&.attributes)
    @shipping = AddressForm.new(user_addresses.shipping.first&.attributes)
  end
end
