require 'rails_helper'

RSpec.describe DeliveryMethod, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:cost).of_type(:float) }
    it { is_expected.to have_db_column(:min_days).of_type(:integer) }
    it { is_expected.to have_db_column(:max_days).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  context 'with assosiations' do
    it { is_expected.to have_many(:orders) }
  end
end
