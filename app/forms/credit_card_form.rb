class CreditCardForm
  include ActiveModel::Model
  include Virtus.model

  ONLY_LETTERS_AND_SPACES_REGEX = %r{\A^[a-zA-Z\s]+$\z}.freeze
  EXPIRE_DATE_FORMAT_MM_YY_REGEX = %r{\A^(0[1-9]|1[0-2])\/?([0-9]{2})$\z}.freeze

  attr_reader :credit_card

  attribute :number, String
  attribute :name, String
  attribute :expire_date, String
  attribute :cvv, Integer

  validates :number,
            presence: true,
            length: { is: 16 },
            numericality: { only_integer: true, message: I18n.t('checkout.errors.only_numbers') }

  validates :name,
            presence: true,
            length: { maximum: 50 },
            format: { with: ONLY_LETTERS_AND_SPACES_REGEX, message: I18n.t('checkout.errors.only_letters') }

  validates :expire_date,
            presence: true,
            format: { with: EXPIRE_DATE_FORMAT_MM_YY_REGEX, message: I18n.t('checkout.errors.expire_date') }

  validates :cvv,
            presence: true,
            length: { in: 3..4 },
            numericality: { only_integer: true, message: I18n.t('checkout.errors.only_numbers') }

  def save(order)
    return false unless valid?

    @order = order
    persist!
    true
  end

  private

  def persist!
    @credit_card = @order.create_credit_card!(number: number, name: name, expire_date: expire_date, cvv: cvv)
  end
end
