require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:total_price).of_type(:decimal) }
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

    context 'when order_present' do
      let(:order) { FactoryBot.create(:order) }
      let(:book) { FactoryBot.create(:book) }
      let(:new_order_item) { OrderItem.create(book_id: book.id, quantity: 1, order_id: order.id) }

      it { expect(new_order_item.errors.messages[:order]).not_to include I18n.t('order_item.error') }
      it { expect(new_order_item).to eq OrderItem.last }
    end

    context 'when order_id_nil' do
      let(:new_order_item) { OrderItem.create(book_id: 1, quantity: 1) }

      it { expect(new_order_item.errors.messages[:order]).to include I18n.t('order_item.error') }
      it { expect(new_order_item).not_to eq OrderItem.last }
    end
  end
end
