class AddressForm
  include ActiveModel::Model
  include Virtus.model

  ONLY_LETTERS_REGEX = /\A^[a-zA-Z]+$\z/.freeze
  ADDRESS_REGEX = /[a-zA-Z0-9'`"-]/.freeze
  PLUS_WITH_NUMBERS_PHONE_REGEX = /\+{1}[0-9]/.freeze
  TEXT_FIELD_MAX_LENGHT = 50
  ZIP_MAX_LENGHT = 10
  PHONE_MAX_LENGHT = 15

  attribute :first_name, String
  attribute :last_name, String
  attribute :country, String
  attribute :city, String
  attribute :street, String
  attribute :zip, Integer
  attribute :phone, String
  attribute :kind, String
  attribute :id, Integer

  validates :first_name, :last_name, :country, :city,
            presence: true,
            length: { maximum: TEXT_FIELD_MAX_LENGHT },
            format: { with: ONLY_LETTERS_REGEX, message: I18n.t('checkout.errors.only_letters') }

  validates :street,
            presence: true,
            length: { maximum: TEXT_FIELD_MAX_LENGHT },
            format: { with: ADDRESS_REGEX, message: I18n.t('checkout.errors.address') }

  validates :zip,
            presence: true,
            length: { maximum: ZIP_MAX_LENGHT },
            numericality: { only_integer: true, message: I18n.t('checkout.errors.only_numbers') }

  validates :phone,
            presence: true,
            length: { maximum: PHONE_MAX_LENGHT },
            format: { with: PLUS_WITH_NUMBERS_PHONE_REGEX, message: I18n.t('checkout.errors.phone') }

  validates :kind,
            presence: true,
            inclusion: { in: [Address::KINDS[:billing], Address::KINDS[:shipping]] }

  def save(entity)
    return false unless valid?

    entity.addresses.find_or_initialize_by(kind: kind).update_attributes(params)
  end

  private

  def params
    { first_name: first_name, last_name: last_name, street: street,
      country: country, city: city, zip: zip, phone: phone, kind: kind }
  end
end
