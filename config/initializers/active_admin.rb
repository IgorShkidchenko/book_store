ActiveAdmin.setup do |config|
  config.site_title = "Book Store"
  config.site_title_image = 'http://itcluster.dp.ua/wp-content/uploads/2018/07/rg400x200.png'
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.batch_actions = true
  config.localize_format = :long

  ActiveAdmin::ResourceController.class_eval do
    def find_resource
      finder = resource_class.is_a?(FriendlyId) ? :slug : :id
      scoped_collection.find_by(finder => params[:id])
    end
  end
end
