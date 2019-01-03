require 'rails_helper'

RSpec.describe BookAuthor, type: :model do
  context 'assosiation' do
    it { should belong_to(:author) }
    it { should belong_to(:book) }
  end
end
