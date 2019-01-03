require 'rails_helper'

RSpec.describe Author, type: :model do

  context 'data_base_column' do
    it { should have_db_column(:name).of_type(:string) }
  end

  context 'assosiation' do
    it { should have_many(:book_authors) }
    it { should have_many(:books).through(:book_authors) }
  end
end
