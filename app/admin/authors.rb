ActiveAdmin.register Author do
  decorate_with AuthorDecorator
  permit_params :name

  config.filters = false
  config.per_page = [10, 50, 100]

  index do
    render 'admin/authors/index', context: self
  end
end
