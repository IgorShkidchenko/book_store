class Checkout::StepValidatorService
  attr_reader :correct_step

  def initialize(order:, step:, authenticate:)
    @order = order
    @step = step
    @authenticate = authenticate
  end

  def call
    @correct_step = main_checkout_validation || validated_step
  end

  def valid?
    @correct_step.eql?(@step)
  end

  private

  def main_checkout_validation
    return CheckoutStepsController::STEPS[:authenticate] unless @authenticate

    CheckoutStepsController::STEPS[:complete] if checkout_in_complete_state?
  end

  def checkout_in_complete_state?
    @step.eql?(CheckoutStepsController::STEPS[:complete]) && @order.editing?
  end

  def validated_step
    @order.editing? ? user_edit_steps : standart_steps_flow
  end

  def standart_steps_flow
    if @order.fill_cart? then CheckoutStepsController::STEPS[:address]
    elsif @order.fill_delivery? then CheckoutStepsController::STEPS[:delivery]
    elsif @order.fill_payment? then CheckoutStepsController::STEPS[:payment]
    end
  end

  def user_edit_steps
    @step.eql?(CheckoutStepsController::STEPS[:authenticate]) ? CheckoutStepsController::STEPS[:edit] : @step
  end
end
