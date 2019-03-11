ActiveAdmin.register Category do
  permit_params :name

  config.filters = false

  index do
    render 'admin/categories/index', context: self
  end
end
