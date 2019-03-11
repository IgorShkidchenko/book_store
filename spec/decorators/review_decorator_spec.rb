require 'rails_helper'

RSpec.describe ReviewDecorator do
  let(:review) { build_stubbed(:review).decorate }

  context 'when creation_date' do
    let(:standart_created_at) { '2019-01-23 15:35:45'.to_time }
    let(:decorated_created_at) { '23/01/19' }

    before { allow(review).to receive(:created_at).and_return(standart_created_at) }

    it { expect(review.creation_date).to eq decorated_created_at }
  end
end
