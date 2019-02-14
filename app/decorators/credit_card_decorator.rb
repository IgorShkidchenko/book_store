class CreditCardDecorator < Draper::Decorator
  MASKED_SYMBOLS = '**** **** **** '.freeze

  delegate_all

  def masked_number
    MASKED_SYMBOLS + number[12..15]
  end
end
