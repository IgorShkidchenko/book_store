class OrderConfirmationMailerWorker
  include Sidekiq::Worker

  def perform(order_id)
    OrderMailer.send_confirmation(Order.find_by(id: order_id)).deliver
  end
end
