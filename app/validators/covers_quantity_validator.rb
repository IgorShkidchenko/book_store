class CoversQuantityValidator < ActiveModel::EachValidator
  MAXIMUM_COVERS_QUANTITY = 4

  def validate_each(record, attribute, value)
    record.errors.add(attribute, I18n.t('book.covers_max_error', max: MAXIMUM_COVERS_QUANTITY)) if size_invalid?(value)
  end

  private

  def size_invalid?(value)
    value.size > MAXIMUM_COVERS_QUANTITY
  end
end
