ActiveAdmin.register Book do
  decorate_with BookDecorator

  permit_params :title, :price, :description, :materials, :published_year,
                :height, :width, :depth, :category_id, author_ids: [], covers_attributes: %i[id book_id image _destroy]

  includes :category, :authors, :covers

  config.filters = false

  index do
    render 'admin/books/index', context: self
  end

  form partial: 'form'

  action_item :show_on_site, only: :show do
    link_to t('admin.actions.show_on_site'), book_path(book)
  end
end
