class CheckoutStepsController < ApplicationController
  include CheckoutStepsHelper
  include Wicked::Wizard

  decorates_assigned :order
  before_action :set_order, :check_cart
  before_action :validate_step, only: :show

  steps :quick_authenticate, :address, :delivery, :payment, :confirm, :complete

  def show
    complete_checkout if step == :complete
    set_checkout_helper
    render_wizard
  end

  def update
    @checkout_helper = chosen_action_service
    @checkout_helper.call ? redirect_to(next_or_confirm_step) : render_wizard
  end

  private

  def validate_step
    @step_validator = Checkout::StepValidatorService.new(order: @order, step: step, authenticate: user_signed_in?)
    @step_validator.call
    if @step_validator.step_invalid?
      flash[:info] = I18n.t('checkout.follow_steps')
      redirect_to(wizard_path(@step_validator.new_step))
    end
  end

  def set_checkout_helper
    @checkout_helper = Checkout::VariablesSetterService.new(@order, step)
    @checkout_helper.call
  end

  def chosen_action_service
    arguments = { order: @order, step: step, params: checkout_params }
    @order.editing? ? Checkout::UpdaterService.new(arguments) : Checkout::CreaterService.new(arguments)
  end

  def next_or_confirm_step
    @order.editing? ? wizard_path(:confirm) : next_wizard_path
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
    return if @order.in_progress?

    redirect_to books_path if @order.order_items.empty?
  end

  def complete_checkout
    session[:order_id] = nil
    Checkout::CompleteService.new(@order).call
  end
end

# TODO: complete aasm
# TODO: order in checkout state
# TODO: send email to user
# TODO: orders active admin
# TODO: verified user
# TODO: most popular books
# TODO: aws
# TODO: orders merge
# TODO: english
