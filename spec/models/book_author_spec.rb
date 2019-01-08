require 'rails_helper'

RSpec.describe BookAuthor, type: :model do
  context 'with assosiation' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:book) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:author_id) }
    it { is_expected.to have_db_index(:book_id) }
  end
end
