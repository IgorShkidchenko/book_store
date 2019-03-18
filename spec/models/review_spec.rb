require 'rails_helper'

RSpec.describe Review, type: :model do
  context 'with database columns' do
    let(:enum_status) { 'unprocessed' }

    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:rating).of_type(:integer).with_options(default: 0) }
    it { is_expected.to have_db_column(:status).of_type(:integer).with_options(default: enum_status) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:book_id) }
    it { is_expected.to have_db_index(:user_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  context 'with enum' do
    it { expect(Review.statuses[:unprocessed]).to eq 0 }
    it { expect(Review.statuses[:approved]).to eq 1 }
    it { expect(Review.statuses[:rejected]).to eq 2 }
  end
end
