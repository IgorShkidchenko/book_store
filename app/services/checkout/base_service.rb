class Checkout::BaseService
  attr_reader :billing, :shipping, :credit_card

  def initialize(order:, step:, params:)
    @order = order
    @step = step
    @params = params
  end

  private

  def addresses_valid?
    @billing.save(@order) & @shipping.save(@order)
  end

  def operation_valid?(condition = nil)
    @operation_valid ||= condition
  end

  def chosen_shipping_address
    return AddressForm.new(@params[:shipping]) unless @params[:clone_address]

    @params[:billing][:kind] = Address::TYPES[:shipping]
    AddressForm.new(@params[:billing])
  end
end
