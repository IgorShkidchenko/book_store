ActiveAdmin.register Book do
  permit_params :title, :price, :description, :materials, :published_year,
                :height, :width, :depth, :cover, :category_id, author_ids: []

  includes :category, :authors

  config.filters = false
  config.per_page = [10, 50, 100]

  index do
    render 'admin/books/index', context: self
  end

  form partial: 'form'
end
