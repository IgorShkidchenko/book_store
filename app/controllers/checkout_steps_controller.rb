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

  before_action :set_checkout_delegator
  before_action :validate_step, only: :show

  steps STEPS[:authenticate], STEPS[:address], STEPS[:delivery], STEPS[:payment], STEPS[:edit], STEPS[:complete]

  def show
    session.delete(:order_id) if step.eql?(STEPS[:complete])
    @checkout_delegator.show
    render_wizard
  end

  def update
    @checkout_delegator.update(checkout_params) ? redirect_to(next_or_edit_step) : render_wizard
  end

  private

  def next_or_edit_step
    current_order.editing? ? wizard_path(STEPS[:edit]) : next_wizard_path
  end

  def validate_step
    return redirect_to(books_path) if @checkout_delegator.cart_empty?

    redirect_to_correct_step unless @checkout_delegator.step_valid?(user_signed_in?)
  end

  def redirect_to_correct_step
    redirect_to(wizard_path(@checkout_delegator.step_validator.correct_step), flash: { info: I18n.t('checkout.follow_steps') })
  end

  def checkout_params
    params.require(:order).permit(:clone_address, :delivery_method_id,
                                  billing: %i[first_name last_name street city zip country phone kind],
                                  shipping: %i[first_name last_name street city zip country phone kind],
                                  credit_card: %i[number name expire_date cvv])
  end

  def set_checkout_delegator
    @checkout_delegator = Checkout::DelegatorService.new(order: current_order, step: step)
  end
end
