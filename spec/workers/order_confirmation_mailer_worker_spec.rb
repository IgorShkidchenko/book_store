require 'rails_helper'

RSpec.describe OrderConfirmationMailerWorker, type: :worker do
  let(:order_fake_id) { 1 }

  it 'when call OrderMailer' do
    expect(OrderMailer).to receive_message_chain(:send_confirmation, :deliver_later)

    subject.perform(order_fake_id)
  end
end
