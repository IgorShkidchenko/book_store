class CreditCardForm
  include ActiveModel::Model
  include Virtus.model

  ONLY_LETTERS_AND_SPACES_REGEX = /\A^[a-zA-Z\s]+$\z/.freeze
  EXPIRE_DATE_FORMAT_MM_YY_REGEX = %r{\A^(0[1-9]|1[0-2])\/?([0-9]{2})$\z}.freeze
  NUMBER_LENGTH = 16
  NAME_MAX_LENGTH = 50
  CVV_RANGE = (3..4).freeze

  attribute :number, String
  attribute :name, String
  attribute :expire_date, String
  attribute :cvv, Integer

  validates :number,
            presence: true,
            length: { is: NUMBER_LENGTH },
            numericality: { only_integer: true, message: I18n.t('checkout.errors.only_numbers') }

  validates :name,
            presence: true,
            length: { maximum: NAME_MAX_LENGTH },
            format: { with: ONLY_LETTERS_AND_SPACES_REGEX, message: I18n.t('checkout.errors.only_letters') }

  validates :expire_date,
            presence: true,
            format: { with: EXPIRE_DATE_FORMAT_MM_YY_REGEX, message: I18n.t('checkout.errors.expire_date') },
            valid_expire_date: true

  validates :cvv,
            presence: true,
            length: { in: CVV_RANGE },
            numericality: { only_integer: true, message: I18n.t('checkout.errors.only_numbers') }

  def save(order)
    return false unless valid?

    @order = order
    @order.credit_card ? modernize! : persist!
    true
  end

  private

  def persist!
    @order.create_credit_card!(number: number, name: name, expire_date: expire_date, cvv: cvv)
  end

  def modernize!
    @order.credit_card.update!(number: number, name: name, expire_date: expire_date, cvv: cvv)
  end
end
