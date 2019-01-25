class ReviewFormatValidator < ActiveModel::EachValidator
  TEXT_REGEX = %r{\A[a-zA-Z0-9!#$%&'*+\-/=?^_`{|},.~\s]+\z}

  def validate_each(record, attribute, value)
    record.errors.add(attribute, I18n.t('review.validation_format_msg')) unless value.match? TEXT_REGEX
  end
end
