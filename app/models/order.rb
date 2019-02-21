class Order < ActiveRecord::Base
  include AASM

  AASM_COLUMN_NAME = 'aasm_state'.freeze
  NEW_STATUS = 'new'.freeze
  STATUSES = {
    in_progress: 'in_progress',
    in_queue: 'in_queue',
    in_delivery: 'in_delivery',
    delivered: 'delivered',
    canceled: 'canceled'
  }.freeze

  aasm column: AASM_COLUMN_NAME do
    state :new, initial: true
    state :fill_delivery
    state :fill_payment
    state :editing
    state :confirmed_by_user
    state :in_progress
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled

    event :fill_delivery do
      transitions from: :new, to: :fill_delivery
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
  end

  belongs_to :user, optional: true
  belongs_to :delivery_method, optional: true

  has_many :order_items, dependent: :destroy
  has_many :books, through: :order_items
  has_one :coupon
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :credit_card, dependent: :destroy
end
