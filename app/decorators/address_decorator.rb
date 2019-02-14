class AddressDecorator < Draper::Decorator
  SPACE = ' '.freeze

  delegate_all

  def city_with_zip
    city + SPACE + zip.to_s
  end

  def full_name
    first_name + SPACE + last_name
  end
end
