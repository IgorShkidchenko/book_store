class Checkout::UpdaterService
  def initialize(order:, params:)
    @order = order
    @params = params
  end

  def change_addresses
    @billing = AddressForm.new(@params[:billing])
    @shipping = chosen_shipping_address
    @order.fill_delivery! if addresses_valid? && @order.may_fill_delivery?
  end

  def change_delivery_method
    delivery = DeliveryMethod.find_by(id: @params[:delivery_method_id])
    return @delivery_methods = DeliveryMethod.all unless valid?(delivery)

    delivery.orders << @order
    @order.fill_payment! if @order.may_fill_payment?
  end

  def change_credit_card
    @credit_card = CreditCardForm.new(@params[:credit_card])
    valid?(@credit_card.save(@order.id))
    @order.editing! if valid? && @order.may_editing?
  end

  def valid?(condition = nil)
    @valid ||= condition
  end

  private

  def addresses_valid?
    valid? (@billing.save(@order) & @shipping.save(@order))
  end

  def chosen_shipping_address
    return AddressForm.new(@params[:shipping]) unless @params[:clone_address]

    @params[:billing][:kind] = Address::TYPES[:shipping]
    AddressForm.new(@params[:billing])
  end
end
