class Checkout::UpdaterService < Checkout::BaseService
  def initialize(order:, step:, params:)
    super(order: order, step: step, params: params)
  end

  def call
    case @step
    when :address then update_addresses
    when :delivery then update_delivery_method
    when :payment then update_credit_card
    end
    operation_valid?
  end

  private

  def update_addresses
    @billing = AddressForm.new(@params[:billing])
    @shipping = chosen_shipping_address
    operation_valid?(addresses_valid?)
  end

  def update_delivery_method
    @order.delivery_method_id = @params[:delivery_method_id]
    operation_valid?(@order.save)
  end

  def update_credit_card
    @credit_card = CreditCardForm.new(@params[:credit_card])
    operation_valid?(@credit_card.save(@order))
  end
end
