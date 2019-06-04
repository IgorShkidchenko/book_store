class Checkout::DelegatorService
  attr_reader :order, :form, :step_validator, :order_items

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
    @params = params
    @form = chosed_updater_service
    @form.call
    @form.valid?
  end

  def step_valid?(authenticate)
    @step_validator = Checkout::StepValidatorService.new(order: @order, step: @step, authenticate: authenticate)
    @step_validator.call
    @step_validator.valid?
  end

  def cart_empty?
    return if @order.may_canceled?

    @order.order_items.empty?
  end

  private

  def chosed_updater_service
    arguments = { order: @order, params: @params }
    case @step
    when CheckoutStepsController::STEPS[:address] then Checkout::Updater::AddressesService.new(arguments)
    when CheckoutStepsController::STEPS[:delivery] then Checkout::Updater::DeliveryMethodsService.new(arguments)
    when CheckoutStepsController::STEPS[:payment] then Checkout::Updater::CreditCardsService.new(arguments)
    end
  end

  def set_order_items
    @order_items = Orders::OrderItemsQuery.call(@order).decorate
  end

  def complete_checkout
    Checkout::CompleteService.call(@order)
    set_order_items
  end
end
