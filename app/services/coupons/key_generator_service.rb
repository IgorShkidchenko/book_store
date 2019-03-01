class Coupons::KeyGeneratorService
  def self.call
    loop do
      new_key = SecureRandom.base64(12)
      return new_key unless Coupon.find_by(key: new_key)
    end
  end
end
