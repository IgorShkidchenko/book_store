ActiveAdmin.register Category do
  permit_params :name

  config.filters = false

  index do
    column :name
    actions defaults: false do |category|
      (link_to t('admin.actions.view'), admin_category_path(category)) +
      (link_to t('admin.actions.edit'), edit_admin_category_path(category)) +
      (link_to t('admin.actions.delete'), admin_category_path(category),
                                                  method: :delete,
                                                  data: { confirm: t('admin.delete_msg', quantity: category.books_count) })
    end.join.html_safe
  end
end
