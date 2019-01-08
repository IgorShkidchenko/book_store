require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'with data_base_column' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:price).of_type(:float) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:height).of_type(:float) }
    it { is_expected.to have_db_column(:width).of_type(:float) }
    it { is_expected.to have_db_column(:depth).of_type(:float) }
    it { is_expected.to have_db_column(:materials).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:category_id) }
  end

  context 'with assosiation' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:book_authors) }
    it { is_expected.to have_many(:authors).through(:book_authors) }
  end
end
