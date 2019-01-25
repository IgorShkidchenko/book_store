require 'rails_helper'

RSpec.describe Review, type: :model do
  context 'with database columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:rating).of_type(:integer).with_options(default: 0) }
    it { is_expected.to have_db_column(:status).of_type(:string).with_options(default: Review::STATUSES[:unprocessed]) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:book_id) }
    it { is_expected.to have_db_index(:user_id) }
  end

  context 'with assosiations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'when validates' do
    context 'with out format' do
      before { allow_any_instance_of(ReviewFormatValidator).to receive(:validate_each) }

      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to validate_length_of(:title).is_at_most(80) }
      it { is_expected.to validate_length_of(:body).is_at_most(500) }
    end

    context 'when format valid' do
      before do
        allow_any_instance_of(Review).to receive(:title).and_return("az!#$%&'*+-/=?^_`{|}~.")
        allow_any_instance_of(Review).to receive(:body).and_return("az!#$%&'*+-/=?^_`{|}~.")
      end

      it { is_expected.to allow_value("az!#$%&'*+-/=?^_`{|}~.").for(:title).with_message(I18n.t('review.validation_format_msg')) }
      it { is_expected.to allow_value("az!#$%&'*+-/=?^_`{|}~.").for(:body).with_message(I18n.t('review.validation_format_msg')) }
    end

    context 'when format invalid' do
      before do
        allow_any_instance_of(Review).to receive(:title).and_return('@')
        allow_any_instance_of(Review).to receive(:body).and_return('@')
      end

      it { is_expected.not_to allow_value('@').for(:title).with_message(I18n.t('review.validation_format_msg')) }
      it { is_expected.not_to allow_value('@').for(:body).with_message(I18n.t('review.validation_format_msg')) }
    end
  end
end
