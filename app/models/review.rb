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

  validates_presence_of :title
end
