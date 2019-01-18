ActiveAdmin.register Category do
  permit_params :name

  config.filters = false
  config.per_page = [10, 50, 100]

  index do
    render 'admin/categories/index', context: self
  end
end
