class CreditCardDecorator < Draper::Decorator
  MASKED_SYMBOLS = '**** **** **** '.freeze
  LAST_FOUR_CARD_NUMBERS = (12..15).freeze

  delegate_all

  def masked_number
    MASKED_SYMBOLS + number[LAST_FOUR_CARD_NUMBERS]
  end
end
