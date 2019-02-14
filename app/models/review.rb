class Review < ApplicationRecord
  TEXT_REGEX = %r{\A[a-zA-Z0-9!#$%&'*+\-/=?^_`{|},.~\s]+\z}.freeze
  STATUSES = {
    unprocessed: 'Unprocessed',
    approved: 'Approved',
    rejected: 'Rejected'
  }.freeze

  belongs_to :user
  belongs_to :book

  scope :unprocessed, -> { where(status: STATUSES[:unprocessed]).includes(:user) }
  scope :approved, -> { where(status: STATUSES[:approved]).includes(:user) }
  scope :rejected, -> { where(status: STATUSES[:rejected]).includes(:user) }

  validates :title,
            presence: true,
            length: { maximum: 80 },
            format: { with: TEXT_REGEX,
                      message: I18n.t('review.validation_format_msg') }

  validates :body,
            presence: true,
            length: { maximum: 500 },
            format: { with: TEXT_REGEX,
                      message: I18n.t('review.validation_format_msg') }
end
