ActiveAdmin.register Author do
  permit_params :name

  config.filters = false

  index do
    render 'admin/authors/index', context: self
  end
end
