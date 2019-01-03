require 'rails_helper'

RSpec.describe Book, type: :model do

  context 'data_base_column' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:price).of_type(:float) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:height).of_type(:float) }
    it { should have_db_column(:width).of_type(:float) }
    it { should have_db_column(:depth).of_type(:float) }
    it { should have_db_column(:materials).of_type(:string) }
  end

  context 'assosiation' do
    it { should belong_to(:category) }
    it { should have_many(:book_authors) }
    it { should have_many(:authors).through(:book_authors) }
  end
end
