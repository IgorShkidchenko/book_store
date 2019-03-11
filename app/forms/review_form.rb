class ReviewForm
  include ActiveModel::Model
  include Virtus.model

  TEXT_REGEX = %r{\A[a-zA-Z0-9!#$%&'*+\-/=?^_`{|},.~\s]+\z}.freeze
  TITLE_MAX_LENGTH = 80
  BODY_MAX_LENGTH = 500

  attribute :title, String
  attribute :body, String
  attribute :rating, Integer
  attribute :user_id, Integer
  attribute :book_id, Integer

  validates :title,
            presence: true,
            length: { maximum: TITLE_MAX_LENGTH },
            format: { with: TEXT_REGEX,
                      message: I18n.t('review.validation_format_msg') }

  validates :body,
            presence: true,
            length: { maximum: BODY_MAX_LENGTH },
            format: { with: TEXT_REGEX,
                      message: I18n.t('review.validation_format_msg') }

  def save
    return false unless valid?

    Review.create!(params)
  end

  private

  def params
    { title: title, body: body, rating: rating, book_id: book_id, user_id: user_id }
  end
end
