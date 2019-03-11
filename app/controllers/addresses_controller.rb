class AddressesController < ApplicationController
  authorize_resource
  respond_to :js
  before_action :change_address

  def create; end

  def update; end

  private

  def change_address
    @address = AddressForm.new(address_params)
    return flash.now[:success] = I18n.t('user_settings.success', kind: kind_name) if @address.save(current_user)

    flash.now[:danger] = @address.errors.full_messages.to_sentence
  end

  def kind_name
    Address.kinds.key(@address.kind).capitalize
  end

  def address_params
    params.require(:address_form).permit(%i[first_name last_name street city zip country phone kind id])
  end
end
