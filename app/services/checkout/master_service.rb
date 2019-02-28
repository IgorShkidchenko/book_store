class Checkout::MasterService
  attr_reader :form, :step_validator, :order_items

  def initialize(order:, step:)
    @order = order
    @step = step
  end

  def show
    @form = Checkout::FormVariablesService.new(@order)
    case @step
    when CheckoutStepsController::STEPS[:address] then @form.set_addresses_variables
    when CheckoutStepsController::STEPS[:delivery] then @form.set_delivery_variable
    when CheckoutStepsController::STEPS[:payment] then @form.set_credit_card_variable
    when CheckoutStepsController::STEPS[:edit] then set_order_items
    when CheckoutStepsController::STEPS[:complete] then complete_checkout
    end
  end

  def update(params)
    @form = Checkout::UpdaterService.new(order: @order, params: params)
    case @step
    when CheckoutStepsController::STEPS[:address] then @form.change_addresses
    when CheckoutStepsController::STEPS[:delivery] then @form.change_delivery_method
    when CheckoutStepsController::STEPS[:payment] then @form.change_credit_card
    end
    @form.valid?
  end

  def step_valid?(authenticate)
    @step_validator = Checkout::StepValidatorService.new(order: @order, step: @step, authenticate: authenticate)
    @step_validator.call
    @step_validator.valid?
  end

  private

  def set_order_items
    @order_items = OrderItemsQuery.new(@order).call.decorate
  end

  def complete_checkout
    Checkout::CompleteService.new(@order).call
    set_order_items
  end
end
