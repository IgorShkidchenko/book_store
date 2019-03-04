require 'rails_helper'

RSpec.describe OrderConfirmationMailerWorker, type: :worker do
  let(:order_fake_id) { 1 }

  it 'when call OrderMailer' do
    allow(Order).to receive(:find_by)
    expect(OrderMailer).to receive_message_chain(:send_confirmation, :deliver)

    subject.perform(order_fake_id)
  end
end
