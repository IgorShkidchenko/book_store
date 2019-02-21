class Checkout::VariablesSetterService < Checkout::BaseService
  attr_reader :delivery_methods, :order_items

  def initialize(order, step)
    super(order: order, step: step)
  end

  def call
    case @step
    when :address then set_addresses_variables
    when :delivery then set_delivery_methods_variable
    when :payment then set_credit_card_variable
    when :confirm then set_variables_for_confrim_page
    when :complete then set_variables_for_complete_page
    end
  end

  private

  def set_addresses_variables
    @billing = address_form(Address::TYPES[:billing])
    @shipping = address_form(Address::TYPES[:shipping])
  end

  def set_delivery_methods_variable
    @delivery_methods = DeliveryMethod.all
  end

  def set_credit_card_variable
    @credit_card = credit_card_form
  end

  def set_variables_for_confrim_page
    @billing = order_address(Address::TYPES[:billing]).decorate
    @shipping = order_address(Address::TYPES[:shipping]).decorate
    @credit_card = @order.credit_card.decorate
    @order_items = decorated_order_items
  end

  def set_variables_for_complete_page
    @billing = order_address(Address::TYPES[:billing]).decorate
    @order_items = decorated_order_items
  end

  def decorated_order_items
    @order.order_items.includes(book: :covers).map(&:decorate)
  end
end
