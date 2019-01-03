require 'rails_helper'

RSpec.describe Category, type: :model do

  context 'data_base_column' do
    it { should have_db_column(:name).of_type(:string) }
  end

  context 'assosiation' do
    it { should have_many(:books) }
  end
end
