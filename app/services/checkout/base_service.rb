class Checkout::BaseService
  attr_reader :billing, :shipping, :credit_card

  def initialize(order:, step:)
    @order = order
    @step = step
  end

  private

  def addresses_valid?
    @billing.valid? && @shipping.valid?
  end

  def operation_valid?(condition = nil)
    @operation_valid ||= condition
  end

  def address_form(kind)
    AddressForm.new(order_address(kind)&.attributes) || AddressForm.new
  end

  def order_address(kind)
    return @order.addresses.billing.load.last if kind == Address::TYPES[:billing]

    @order.addresses.shipping.load.last
  end

  def credit_card_form
    CreditCardForm.new(@order.credit_card&.attributes) || CreditCardForm.new
  end
end
