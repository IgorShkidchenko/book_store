require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:number).of_type(:string) }
    it { is_expected.to have_db_column(:expire_date).of_type(:string) }
    it { is_expected.to have_db_column(:cvv).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:order_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:order) }
  end
end
