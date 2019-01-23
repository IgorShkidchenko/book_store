ActiveAdmin.register Category do
  decorate_with CategoryDecorator
  permit_params :name

  config.filters = false
  config.per_page = [10, 50, 100]

  index do
    render 'admin/categories/index', context: self
  end
end
