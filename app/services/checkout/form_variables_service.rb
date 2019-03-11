class Checkout::FormVariablesService
  attr_reader :billing, :shipping, :credit_card, :delivery_methods

  def initialize(order)
    @order = order
  end

  def call(step)
    case step
    when CheckoutStepsController::STEPS[:address] then set_addresses_variables
    when CheckoutStepsController::STEPS[:delivery] then set_delivery_variable
    when CheckoutStepsController::STEPS[:payment] then set_credit_card_variable
    end
  end

  private

  def set_delivery_variable
    @delivery_methods = DeliveryMethod.all
  end

  def set_credit_card_variable
    @credit_card = CreditCardForm.new(@order.credit_card&.attributes)
  end

  def set_addresses_variables
    @billing = AddressForm.new chosed_address(Address.kinds[:billing])
    @shipping = AddressForm.new chosed_address(Address.kinds[:shipping])
  end

  def chosed_address(kind)
    if kind == Address.kinds[:billing]
      @order.addresses.billing.last&.attributes || @order.user.addresses.billing.last&.attributes
    else
      @order.addresses.shipping.last&.attributes || @order.user.addresses.shipping.last&.attributes
    end
  end
end
