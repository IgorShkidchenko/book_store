module ControllerMacros
  def login_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in FactoryBot.create(:admin_user)
    end
  end
end
