class Checkout::CreaterService < Checkout::BaseService
  attr_reader :delivery_methods

  def initialize(order:, step:, params:)
    super(order: order, step: step, params: params)
  end

  def call
    case @step
    when :address then insert_addresses_to_order
    when :delivery then insert_delivery_method_to_order
    when :payment then insert_credit_card_to_order
    end
    operation_valid?
  end

  private

  def insert_addresses_to_order
    @billing = AddressForm.new(@params[:billing])
    @shipping = chosen_shipping_address
    @order.fill_delivery! if operation_valid?(addresses_valid?)
  end

  def insert_delivery_method_to_order
    id = @params[:delivery_method_id]
    return @delivery_methods = DeliveryMethod.all unless operation_valid?(DeliveryMethod.find_by(id: id))

    @order.update(delivery_method_id: id)
    @order.fill_payment!
  end

  def insert_credit_card_to_order
    @credit_card = CreditCardForm.new(@params[:credit_card])
    @order.editing! if operation_valid?(@credit_card.save(@order))
  end
end
