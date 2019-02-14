class Checkout::VariablesSetterService
  attr_reader :billing, :shipping, :delivery_methods, :credit_card, :order_items

  def initialize(order)
    @order = order
  end

  def set_addresses_variables
    @billing = @order.user.addresses.first || @order.addresses.billing || AddressForm.new
    @shipping = @order.addresses.shipping || AddressForm.new
  end

  def set_delivery_methods_variable
    @delivery_methods = DeliveryMethod.all
  end

  def set_credit_card_variable
    @credit_card = (@order.credit_card || CreditCardForm.new)
  end

  def set_variables_for_confrim_page
    @billing = @order.addresses.billing.decorate
    @shipping = @order.addresses.shipping.decorate
    @credit_card = @order.credit_card.decorate
    @order_items = @order.order_items.map(&:decorate)
  end

  def set_variables_for_complete_page
    @billing = @order.addresses.billing.decorate
    @order_items = @order.order_items.map(&:decorate)
  end
end
