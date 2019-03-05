require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:aasm_state).of_type(:integer) }
    it { is_expected.to have_db_column(:number).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:delivery_method_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:delivery_method) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:order_items) }
    it { is_expected.to have_one(:coupon) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
    it { is_expected.to have_one(:credit_card).dependent(:destroy) }
  end
end
