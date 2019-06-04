class CouponForm
  include ActiveModel::Model
  include Virtus.model

  attribute :key, String

  validate :coupon_existing, :coupon_was_unused

  def save(order)
    @coupon = Coupon.find_by(key: key)
    return false unless valid?

    @coupon.update_attributes(order_id: order.id)
  end

  private

  def coupon_existing
    errors.add(:base, I18n.t('coupon.error_havent')) unless @coupon
  end

  def coupon_was_unused
    errors.add(:base, I18n.t('coupon.error_used')) if @coupon&.used
  end
end
