class OrderConfirmationMailerWorker
  include Sidekiq::Worker

  def perform(order_id)
    OrderMailer.send_confirmation(finded_order(order_id)).deliver_later
  end

  private

  def finded_order(order_id)
    Order.find_by(id: order_id)
  end
end
