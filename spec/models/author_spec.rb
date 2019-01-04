require 'rails_helper'

RSpec.describe Author, type: :model do
  context 'with data_base_column' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  context 'with assosiation' do
    it { is_expected.to have_many(:book_authors) }
    it { is_expected.to have_many(:books).through(:book_authors) }
  end
end
