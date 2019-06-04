require 'rails_helper'

RSpec.describe Cover, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:image).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:book_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:book) }
  end
end
