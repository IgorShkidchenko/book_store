class Review < ApplicationRecord
  STATUSES = {
    unprocessed: 'Unprocessed',
    approved: 'Approved',
    rejected: 'Rejected'
  }.freeze

  belongs_to :user
  delegate :email, to: :user, prefix: true
  belongs_to :book

  scope :unprocessed, -> { where(status: STATUSES[:unprocessed]) }
  scope :approved, -> { where(status: STATUSES[:approved]) }
  scope :rejected, -> { where(status: STATUSES[:rejected]) }

  validates :title,
            presence: true,
            length: { maximum: 80 },
            format: {
              with: %r{\A[\w!#$%&'*+\-/=?^_`{|}~\s]+.\z},
              message: I18n.t('review.validation_format_msg')
            }

  validates :body,
            presence: true,
            length: { maximum: 500 },
            format: {
              with: %r{\A[\w!#$%&'*+\-/=?^_`{|}~\s]+.\z},
              message: I18n.t('review.validation_format_msg')
            }
end
