class CheckoutStepsController < ApplicationController
  STEPS = {
    authenticate: :quick_authenticate,
    address: :address,
    delivery: :delivery,
    payment: :payment,
    edit: :confirm,
    complete: :complete
  }.freeze

  include CheckoutStepsHelper
  include Wicked::Wizard

  decorates_assigned :order
  before_action :set_order, :check_cart
  before_action :validate_step, only: :show

  steps STEPS[:authenticate], STEPS[:address], STEPS[:delivery], STEPS[:payment], STEPS[:edit], STEPS[:complete]

  def show
    step == STEPS[:complete] ? complete_checkout : set_checkout_helper
    render_wizard
  end

  def update
    @checkout_helper = Checkout::DelegatorService.new(order: @order, step: step, params: checkout_params).call
    @checkout_helper.call ? redirect_to(next_or_edit_step) : render_wizard
  end

  private

  def validate_step
    @step_validator = Checkout::StepValidatorService.new(order: @order, step: step, authenticate: user_signed_in?)
    @step_validator.call
    return if @step_validator.valid?

    flash[:info] = I18n.t('checkout.follow_steps')
    redirect_to(wizard_path(@step_validator.new_step))
  end

  def set_checkout_helper
    @checkout_helper = Checkout::VariablesSetterService.new(@order, step)
    @checkout_helper.call
  end

  def next_or_edit_step
    @order.editing? ? wizard_path(STEPS[:edit]) : next_wizard_path
  end

  def checkout_params
    params.require(:order).permit(:clone_address, :delivery_method_id, :complete,
                                  billing: %i[first_name last_name street city zip country phone kind],
                                  shipping: %i[first_name last_name street city zip country phone kind],
                                  credit_card: %i[number name expire_date cvv])
  end

  def set_order
    @order = current_order
  end

  def check_cart
    return if @order.may_canceled?

    redirect_to books_path if @order.order_items.empty?
  end

  def complete_checkout
    session[:order_id] = nil
    Checkout::CompleteService.new(@order).call
    set_checkout_helper
  end
end
