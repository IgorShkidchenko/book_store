class AddressesController < ApplicationController
  respond_to :js

  def create
    change_address
  end

  def update
    change_address
  end

  private

  def change_address
    address = AddressForm.new(address_params)
    return flash.now[:danger] = address.errors.full_messages.to_sentence unless address.save(current_user)

    flash.now[:success] = I18n.t('user_settings.success', kind: address.kind.capitalize)
  end

  def address_params
    params.require(:address_form).permit(%i[first_name last_name street city zip country phone kind])
  end
end
