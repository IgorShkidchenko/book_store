class ReviewDecorator < Draper::Decorator
  delegate_all
  delegate :email, to: :user, prefix: true

  def creation_date
    created_at.strftime('%d/%m/%y')
  end
end
