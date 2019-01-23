require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:price).of_type(:float) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:height).of_type(:float) }
    it { is_expected.to have_db_column(:width).of_type(:float) }
    it { is_expected.to have_db_column(:depth).of_type(:float) }
    it { is_expected.to have_db_column(:materials).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:cover).of_type(:string) }
    it { is_expected.to have_db_column(:slug).of_type(:string) }
    it { is_expected.to have_db_index(:category_id) }
    it { is_expected.to have_db_index(:slug).unique }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:book_authors) }
    it { is_expected.to have_many(:authors).through(:book_authors).dependent(:destroy) }
  end

  context 'when #latest_three' do
    before { FactoryBot.create_list(:book, 4) }

    let(:method_result) { Book.latest_three }
    let(:limit_size) { 3 }

    it { expect(method_result.size).to eq limit_size }
    it { expect(method_result.first.id).to eq Book.last.id }
  end
end
