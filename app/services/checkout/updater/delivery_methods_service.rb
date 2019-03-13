class Checkout::Updater::DeliveryMethodsService < Checkout::Updater::BaseService
  attr_reader :delivery_methods

  def initialize(order:, params:)
    super(order: order, params: params)
  end

  def call
    @id = @params[:delivery_method_id]
    valid?(DeliveryMethod.where(id: @id).exists?) ? modernize : return_delivery_methods
  end

  private

  def modernize
    @order.update(delivery_method_id: @id)
    @order.fill_payment! if order_can_be_changed?
  end

  def return_delivery_methods
    @delivery_methods = DeliveryMethod.all
  end
end
