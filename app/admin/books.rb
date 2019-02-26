ActiveAdmin.register Book do
  decorate_with BookDecorator
  permit_params :title, :price, :description, :materials, :published_year,
                :height, :width, :depth, :category_id, author_ids: [], covers_attributes: %i[id book_id image _destroy]

  includes :category, :authors, :covers

  config.filters = false
  config.per_page = [10, 50, 100]

  index do
    render 'admin/books/index', context: self
  end

  form partial: 'form'

  action_item :show_on_site, only: :show do
    link_to t('admin.actions.show_on_site'), books_path(book)
  end

  action_item :create_with_faker, only: :new do
    book_params = {
      title: Faker::Book.title,
      price: Faker::Number.decimal(2),
      description: Faker::Lorem.paragraph_by_chars(Faker::Number.between(300, 350), false),
      published_year: Faker::Number.between(2000, Time.now.year),
      height: Faker::Number.decimal(2),
      width: Faker::Number.decimal(2),
      depth: Faker::Number.decimal(2),
      materials: Faker::Science.element,
      category_id: Category.first.id
    }
    link_to t('admin.actions.create_with_faker'), admin_books_path(book: book_params), method: :post if Category.first
  end
end
