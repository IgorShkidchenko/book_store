require 'rails_helper'

RSpec.describe Author, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  context 'with assosiations' do
    it { is_expected.to have_many(:book_authors) }
    it { is_expected.to have_many(:books).through(:book_authors).dependent(:destroy) }
  end

  context 'when validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
