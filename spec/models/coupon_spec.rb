require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:key).of_type(:string) }
    it { is_expected.to have_db_column(:discount).of_type(:integer).with_options(default: 10) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:order_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:order).without_validating_presence }
  end
end
