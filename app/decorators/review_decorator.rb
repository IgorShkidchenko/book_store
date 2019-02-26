class ReviewDecorator < Draper::Decorator
  DAY_MONTH_YEAR = '%d/%m/%y'.freeze

  delegate_all
  delegate :email, to: :user, prefix: true

  def creation_date
    created_at.strftime(DAY_MONTH_YEAR)
  end
end
