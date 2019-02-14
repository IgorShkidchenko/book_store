class Checkout::UpdaterService
  attr_reader :billing, :shipping, :credit_card, :order, :valid

  def initialize(order)
    @order = order
  end

  def insert_addresses_to_order(params)
    @billing = AddressForm.new(params[:billing])
    @shipping = chosen_shipping_address(params)
    @billing.save(@order)
    @shipping.save(@order)
    @valid = addresses_created_successfully?
  end

  def insert_delivery_method_to_order(params)
    @order.delivery_method_id = params[:delivery_method_id]
    @valid = @order.save
    UpdateTotalPricesService.new(order: @order).call if @valid
  end

  def insert_credit_card_to_order(params)
    @credit_card = CreditCardForm.new(params)
    @valid = @credit_card.save(@order)
  end

  private

  def chosen_shipping_address(params)
    return AddressForm.new(params[:shipping]) unless params[:clone_address]

    params[:billing][:kind] = Address::TYPES[:shipping]
    AddressForm.new(params[:billing])
  end

  def addresses_created_successfully?
    @billing.valid? && @shipping.valid?
  end
end
