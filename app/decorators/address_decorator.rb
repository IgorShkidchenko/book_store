class AddressDecorator < Draper::Decorator
  delegate_all

  def city_with_zip
    "#{city} #{zip}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
