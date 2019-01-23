require 'rails_helper'

RSpec.describe ReviewDecorator do
  let(:review) { FactoryBot.build_stubbed(:review).decorate }

  context 'when creation_date' do
    let(:standart_created_at) { '2019-01-23 15:35:45' }
    let(:decorated_created_at) { '23/01/19' }

    before { review.created_at = standart_created_at }

    it { expect(review.creation_date).to eq decorated_created_at }
  end
end
