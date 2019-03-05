class Review < ApplicationRecord
  STATUSES = {
    unprocessed: 0,
    approved: 1,
    rejected: 2
  }.freeze

  belongs_to :user
  belongs_to :book

  enum status: { unprocessed: STATUSES[:unprocessed], approved: STATUSES[:approved], rejected: STATUSES[:rejected] }

  scope :unprocessed, -> { where(status: STATUSES[:unprocessed]).includes(:user) }
  scope :approved, -> { where(status: STATUSES[:approved]).includes(:user) }
  scope :rejected, -> { where(status: STATUSES[:rejected]).includes(:user) }
end
