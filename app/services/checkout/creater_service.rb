class Checkout::CreaterService < Checkout::BaseService
  attr_reader :delivery_methods

  def initialize(order:, step:, params:)
    super(order: order, step: step)
    @params = params
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
    if operation_valid?(addresses_valid?)
      @billing.save(@order)
      @shipping.save(@order)
      @order.fill_delivery!
    end
  end

  def insert_delivery_method_to_order
    finded_delivery = DeliveryMethod.find_by(id: @params[:delivery_method_id])
    if operation_valid?(finded_delivery)
      @order.update(delivery_method_id: finded_delivery.id)
      @order.fill_payment!
    else
      @delivery_methods = DeliveryMethod.all
    end
  end

  def insert_credit_card_to_order
    @credit_card = CreditCardForm.new(@params[:credit_card])
    @order.editing! if operation_valid?(@credit_card.save(@order))
  end

  def chosen_shipping_address
    return AddressForm.new(@params[:shipping]) unless @params[:clone_address]

    @params[:billing][:kind] = Address::TYPES[:shipping]
    AddressForm.new(@params[:billing])
  end
end
