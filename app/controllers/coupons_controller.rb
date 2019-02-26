class CouponsController < ApplicationController
  respond_to :js

  def update
    @order = Order.find_by(id: coupon_params[:order_id])
    @coupon = Coupon.find_by(key: coupon_params[:key])
    return flash.now[:danger] = I18n.t('coupon.error_havent') unless @coupon
    return flash.now[:danger] = I18n.t('coupon.error_used') if @coupon.used

    set_coupon_to_order
  end

  private

  def coupon_params
    params.require(:coupon).permit(:key, :order_id)
  end

  def set_coupon_to_order
    @coupon.update(order_id: @order.id)
  end
end
