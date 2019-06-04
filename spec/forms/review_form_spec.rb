require 'rails_helper'

RSpec.describe ReviewForm, type: :model do
  let(:invalid_input) { '@' }
  let(:valid_input) { "text 0-9!#$%&'*+-=?^_`{|},.~" }
  let(:message) { I18n.t('review.validation_format_msg') }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:title).is_at_most(ReviewForm::TITLE_MAX_LENGTH) }
  it { is_expected.to validate_length_of(:body).is_at_most(ReviewForm::BODY_MAX_LENGTH) }
  it { is_expected.to allow_value(valid_input).for(:title).with_message(message) }
  it { is_expected.to allow_value(valid_input).for(:body).with_message(message) }
  it { is_expected.not_to allow_value(invalid_input).for(:title).with_message(message) }
  it { is_expected.not_to allow_value(invalid_input).for(:body).with_message(message) }

  context 'when credit card #save' do
    subject(:review_form) { described_class.new(params) }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:params) { attributes_for(:review).merge(user_id: user.id, book_id: book.id) }

    it 'when successfuly' do
      expect { review_form.save }.to change(Review, :count).by(1)
    end

    it 'when failed' do
      allow(review_form).to receive(:valid?).and_return(false)
      expect { review_form.save }.to change(Review, :count).by(0)
    end
  end
end
