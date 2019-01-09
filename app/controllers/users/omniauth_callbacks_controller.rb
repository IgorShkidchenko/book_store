class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    user = User.from_omniauth(request.env['omniauth.auth'])
    user.persisted? ? sign_in_and_redirect(user, event: :authentication) : failed_login
  end

  def failure
    redirect_to root_path
  end

  private

  def failed_login
    session['devise.facebook_data'] = request.env['omniauth.auth']
    redirect_to new_user_registration_url
  end
end
