class Checkout::UpdaterService < Checkout::BaseService
  def initialize(order:, step:, params:)
    super(order: order, step: step)
    @params = params
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
    @billing = address_form(Address::TYPES[:billing])
    @shipping = address_form(Address::TYPES[:shipping])
    if operation_valid?(addresses_valid?)
      order_address(Address::TYPES[:billing]).update(@params[:billing])
      @params[:clone_address] ? clone_address : order_address(Address::TYPES[:shipping]).update(@params[:shipping])
    end
  end

  def update_delivery_method
    @order.delivery_method_id = @params[:delivery_method_id]
    operation_valid?(@order.save)
  end

  def update_credit_card
    @credit_card = credit_card_form
    @order.credit_card.update(@params[:credit_card]) if operation_valid?(@credit_card.valid?)
  end

  def clone_address
    @params[:billing][:kind] = Address::TYPES[:shipping]
    order_address(Address::TYPES[:shipping]).update(@params[:billing])
  end
end
