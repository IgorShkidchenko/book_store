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

  before_action :set_order_and_checkout_master, :check_cart
  before_action :validate_step, only: :show
  decorates_assigned :order

  steps STEPS[:authenticate], STEPS[:address], STEPS[:delivery], STEPS[:payment], STEPS[:edit], STEPS[:complete]

  def show
    clear_order_session if step == STEPS[:complete]
    @checkout.show
    render_wizard
  end

  def update
    @checkout.update(checkout_params) ? redirect_to(next_or_edit_step) : render_wizard
  end

  private

  def next_or_edit_step
    @order.editing? ? wizard_path(STEPS[:edit]) : next_wizard_path
  end

  def validate_step
    return if @checkout.step_valid?(user_signed_in?)

    flash[:info] = I18n.t('checkout.follow_steps')
    redirect_to(wizard_path(@checkout.step_validator.new_step))
  end

  def checkout_params
    params.require(:order).permit(:clone_address, :delivery_method_id, :complete,
                                  billing: %i[first_name last_name street city zip country phone kind],
                                  shipping: %i[first_name last_name street city zip country phone kind],
                                  credit_card: %i[number name expire_date cvv])
  end

  def set_order_and_checkout_master
    @order = current_order
    @checkout = Checkout::MasterService.new(order: @order, step: step)
  end

  def check_cart
    return if @order.may_canceled?

    redirect_to books_path if @order.order_items.empty?
  end

  def clear_order_session
    session[:order_id] = nil
  end
end
