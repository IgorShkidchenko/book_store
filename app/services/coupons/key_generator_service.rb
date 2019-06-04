class Coupons::KeyGeneratorService
  MILISEC_SEC_MINUTE = '%s%S%m'.freeze

  def self.call
    loop do
      new_key = Time.now.strftime(MILISEC_SEC_MINUTE) + SecureRandom.hex(5)
      return new_key unless Coupon.where(key: new_key).exists?
    end
  end
end
