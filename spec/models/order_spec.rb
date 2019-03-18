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
    it { is_expected.to belong_to(:user).without_validating_presence }
    it { is_expected.to belong_to(:delivery_method).without_validating_presence }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:order_items) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
    it { is_expected.to have_one(:coupon) }
    it { is_expected.to have_one(:credit_card).dependent(:destroy) }
  end

  context 'with enum' do
    it { expect(Order.aasm_states[:fill_cart]).to eq 0 }
    it { expect(Order.aasm_states[:fill_delivery]).to eq 1 }
    it { expect(Order.aasm_states[:fill_payment]).to eq 2 }
    it { expect(Order.aasm_states[:editing]).to eq 3 }
    it { expect(Order.aasm_states[:in_progress]).to eq 4 }
    it { expect(Order.aasm_states[:in_queue]).to eq 5 }
    it { expect(Order.aasm_states[:in_delivery]).to eq 6 }
    it { expect(Order.aasm_states[:delivered]).to eq 7 }
    it { expect(Order.aasm_states[:canceled]).to eq 8 }
  end
end
