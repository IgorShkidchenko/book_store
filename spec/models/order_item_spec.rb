require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:order_id) }
    it { is_expected.to have_db_index(:book_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'when validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
