require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  context 'when #send_confirmation' do
    subject(:order_mailer) { described_class.send_confirmation(order) }

    let(:order) { create(:order_in_checkout_form_steps) }
    let(:user_email) { order.user.email }

    it { expect(subject.subject).to eq I18n.t('mailer.order.subject') }
    it { expect(subject.to).to eq [user_email] }
    it { expect(subject.from).to eq [ApplicationMailer::DEFAULT_EMAIL] }
    it { expect(subject.body.encoded).to match I18n.t('mailer.order.message', number: order.number) }
  end
end
