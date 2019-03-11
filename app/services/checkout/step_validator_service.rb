class Checkout::StepValidatorService
  attr_reader :correct_step

  def initialize(order:, step:, authenticate:)
    @order = order
    @step = step
    @authenticate = authenticate
  end

  def call
    main_checkout_validation
    return if @correct_step

    @correct_step = validated_step
  end

  def valid?
    @correct_step.eql?(@step)
  end

  private

  def main_checkout_validation
    @correct_step = CheckoutStepsController::STEPS[:authenticate] unless @authenticate
    @correct_step = CheckoutStepsController::STEPS[:complete] if checkout_in_complete_state?
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
    current_step_disallowed_on_edit_step? ? CheckoutStepsController::STEPS[:edit] : @step
  end

  def current_step_disallowed_on_edit_step?
    [CheckoutStepsController::STEPS[:complete], CheckoutStepsController::STEPS[:authenticate]].include?(@step)
  end
end
