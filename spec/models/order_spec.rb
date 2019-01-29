require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:total_price).of_type(:decimal) }
    # it { is_expected.to have_db_column(:order_status_id).of_type(:bigint) }
    # it { is_expected.to have_db_column(:user_id).of_type(:bigint) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:order_status_id) }
    it { is_expected.to have_db_index(:user_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:order_status) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:order_items) }
  end
end
