class Review < ApplicationRecord
  include AASM

  AASM_COLUMN_NAME = 'status'.freeze

  belongs_to :user
  belongs_to :book

  enum status: { unprocessed: 0, approved: 1, rejected: 2 }

  aasm column: AASM_COLUMN_NAME, enum: true do
    state :unprocessed, initial: true
    state :approved
    state :rejected

    event :approved do
      transitions from: :unprocessed, to: :approved
    end

    event :rejected do
      transitions from: :unprocessed, to: :rejected
    end
  end
end
