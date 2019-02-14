class ReviewDecorator < Draper::Decorator
  TWO_DIGIT_DAY_MONTH_YEAR = '%d/%m/%y'.freeze

  delegate_all
  delegate :email, to: :user, prefix: true

  def creation_date
    created_at.strftime(TWO_DIGIT_DAY_MONTH_YEAR)
  end
end
