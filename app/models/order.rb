class Order < ActiveRecord::Base
  include AASM

  AASM_COLUMN_NAME = 'aasm_state'.freeze
  STATUSES = {
    checkout: {
      fill_cart: 0,
      fill_delivery: 1,
      fill_payment: 2,
      editing: 3
    },
    processing: {
      in_progress: 4,
      in_queue: 5,
      in_delivery: 6,
      delivered: 7,
      canceled: 8
    }
  }.freeze

  belongs_to :user, optional: true
  belongs_to :delivery_method, optional: true

  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :coupon, dependent: :nullify
  has_one :credit_card, dependent: :destroy

  enum aasm_state: { fill_cart: STATUSES[:checkout][:fill_cart], fill_delivery: STATUSES[:checkout][:fill_delivery],
                     fill_payment: STATUSES[:checkout][:fill_payment], editing: STATUSES[:checkout][:editing],
                     in_progress: STATUSES[:processing][:in_progress], in_queue: STATUSES[:processing][:in_queue],
                     in_delivery: STATUSES[:processing][:in_delivery], delivered: STATUSES[:processing][:delivered],
                     canceled: STATUSES[:processing][:canceled] }

  scope :user_checkout_orders, ->(user_id) { where(aasm_state: STATUSES[:checkout].values, user_id: user_id) }

  aasm column: AASM_COLUMN_NAME, enum: true do
    state :fill_cart, initial: true
    state :fill_delivery
    state :fill_payment
    state :editing
    state :in_progress
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled

    event :fill_delivery do
      transitions from: :fill_cart, to: :fill_delivery
    end

    event :fill_payment do
      transitions from: :fill_delivery, to: :fill_payment
    end

    event :editing do
      transitions from: :fill_payment, to: :editing
    end

    event :in_progress do
      transitions from: :editing, to: :in_progress
    end

    event :in_queue do
      transitions from: :in_progress, to: :in_queue
    end

    event :in_delivery do
      transitions from: :in_queue, to: :in_delivery
    end

    event :delivered do
      transitions from: :in_delivery, to: :delivered
    end

    event :canceled do
      transitions from: %i[in_progress in_queue in_delivery delivered], to: :canceled
    end
  end
end
