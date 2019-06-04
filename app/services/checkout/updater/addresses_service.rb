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
    @params[:clone_address] ? cloning_shipping_address_from_billing_address : set_shipping_address
  end

  def cloning_shipping_address_from_billing_address
    @order.toggle!(:use_the_same_address) unless @order.use_the_same_address
    @params[:billing][:kind] = Address.kinds[:shipping]
    AddressForm.new(@params[:billing])
  end

  def set_shipping_address
    @order.toggle!(:use_the_same_address) if @order.use_the_same_address
    AddressForm.new(@params[:shipping])
  end
end
