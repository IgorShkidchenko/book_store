class Checkout::Updater::CreditCardsService < Checkout::Updater::BaseService
  attr_reader :credit_card

  def initialize(order:, params:)
    super(order: order, params: params)
  end

  def call
    @credit_card = CreditCardForm.new(@params[:credit_card])
    valid? @credit_card.save(@order.id)
    @order.editing! if order_can_be_changed?
  end
end
