class Checkout::StepValidatorService
  attr_reader :new_step

  def initialize(order:, step:, authenticate:)
    @order = order
    @step = step
    @authenticate = authenticate
  end

  def call
    return @new_step = CheckoutStepsController::STEPS[:authenticate] unless @authenticate
    return @new_step = CheckoutStepsController::STEPS[:complete] if checkout_in_complete_state

    @order.editing? ? user_edit_step : standart_steps_flow
  end

  def valid?
    @new_step == @step
  end

  private

  def standart_steps_flow
    if @order.new? then @new_step = CheckoutStepsController::STEPS[:address]
    elsif @order.fill_delivery? then @new_step = CheckoutStepsController::STEPS[:delivery]
    elsif @order.fill_payment? then @new_step = CheckoutStepsController::STEPS[:payment]
    end
  end

  def user_edit_step
    return @new_step = CheckoutStepsController::STEPS[:edit] if current_step_disallowed_on_edit_step

    @new_step = @step
  end

  def checkout_in_complete_state
    @step == CheckoutStepsController::STEPS[:complete] && @order.editing?
  end

  def current_step_disallowed_on_edit_step
    @step == CheckoutStepsController::STEPS[:complete] && @step == CheckoutStepsController::STEPS[:authenticate]
  end
end
