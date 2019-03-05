class OrderMailer < ApplicationMailer
  def send_confirmation(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: 'bookstore')
  end
end
