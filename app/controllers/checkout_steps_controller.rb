class CheckoutStepsController < ApplicationController
  include Wicked::Wizard

  decorates_assigned :order
  before_action :set_order

  steps :checkout_sign_in, :address, :delivery, :payment, :confirm, :complete

  def show
    @checkout_helper = Checkout::VariablesSetterService.new(@order)
    case step
    when :address then @checkout_helper.set_addresses_variables
    when :delivery then @checkout_helper.set_delivery_methods_variable
    when :payment then @checkout_helper.set_credit_card_variable
    when :confirm then @checkout_helper.set_variables_for_confrim_page
    when :complete then @checkout_helper.set_variables_for_complete_page
    end
    render_wizard
  end

  def update
    @checkout_helper = Checkout::UpdaterService.new(@order)
    case step
    when :address then @checkout_helper.insert_addresses_to_order(checkout_params)
    when :delivery then @checkout_helper.insert_delivery_method_to_order(checkout_params)
    when :payment then @checkout_helper.insert_credit_card_to_order(card_params)
    end
    @checkout_helper.valid ? redirect_to(next_wizard_path) : render_wizard
  end

  private

  def checkout_params
    params.require(:checkout).permit(:clone_address, :delivery_method_id,
                                     billing: %i[first_name last_name address city zip country phone kind],
                                     shipping: %i[first_name last_name address city zip country phone kind])
  end

  def card_params
    params.require(:credit_card).permit(:number, :name, :expire_date, :cvv)
  end

  def set_order
    @order = current_order
  end
end
