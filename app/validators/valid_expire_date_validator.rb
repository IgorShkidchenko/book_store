class ValidExpireDateValidator < ActiveModel::EachValidator
  CENTURY = 2000
  MONTH_DIGITS = (0..1).freeze
  YEAR_DIGITS = (3..4).freeze

  def validate_each(record, attribute, value)
    record.errors.add(attribute, I18n.t('checkout.errors.invalid_expire_date')) unless date_invalid?(value)
  end

  private

  def date_invalid?(value)
    time = Time.now
    month_in_the_past?(value, time) && year_in_the_past?(value, time)
  end

  def month_in_the_past?(value, time)
    value[MONTH_DIGITS].to_i >= time.month
  end

  def year_in_the_past?(value, time)
    value[YEAR_DIGITS].to_i >= (time.year - CENTURY)
  end
end
