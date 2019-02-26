class Review < ApplicationRecord
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
end
