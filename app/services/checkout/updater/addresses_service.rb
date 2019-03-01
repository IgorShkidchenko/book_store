class Checkout::Updater::AddressesService < Checkout::Updater::BaseService
  attr_reader :billing, :shipping

  def initialize(order:, params:)
    super(order: order, params: params)
  end

  def call
    @billing = AddressForm.new(@params[:billing])
    @shipping = chosen_shipping_address
    valid?(addresses_valid?)
    @order.fill_delivery! if order_can_be_changed?
  end

  private

  def addresses_valid?
    @billing.save(@order) & @shipping.save(@order)
  end

  def chosen_shipping_address
    return AddressForm.new(@params[:shipping]) unless @params[:clone_address]

    @params[:billing][:kind] = Address::KINDS[:shipping]
    AddressForm.new(@params[:billing])
  end
end
