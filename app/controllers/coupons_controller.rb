class CouponsController < ApplicationController
  authorize_resource
  respond_to :js

  def update
    coupon = CouponForm.new(coupon_params)
    flash.now[:danger] = coupon.errors.full_messages.to_sentence unless coupon.save(current_order)
  end

  private

  def coupon_params
    params.require(:coupon).permit(:key)
  end
end
