class Checkout::MasterService
  attr_reader :form, :step_validator, :order_items

  def initialize(order:, step:)
    @order = order
    @step = step
  end

  def show
    case @step
    when CheckoutStepsController::STEPS[:authenticate] then nil
    when CheckoutStepsController::STEPS[:edit] then set_order_items
    when CheckoutStepsController::STEPS[:complete] then complete_checkout
    else
      @form = Checkout::FormVariablesService.new(@order)
      @form.call(@step)
    end
  end

  def update(params)
    arguments = { order: @order, params: params }
    case @step
    when CheckoutStepsController::STEPS[:address] then @form = Checkout::Updater::AddressesService.new(arguments)
    when CheckoutStepsController::STEPS[:delivery] then @form = Checkout::Updater::DeliveryMethodsService.new(arguments)
    when CheckoutStepsController::STEPS[:payment] then @form = Checkout::Updater::CreditCardsService.new(arguments)
    end
    @form.call
    @form.valid?
  end

  def step_valid?(authenticate)
    @step_validator = Checkout::StepValidatorService.new(order: @order, step: @step, authenticate: authenticate)
    @step_validator.call
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
