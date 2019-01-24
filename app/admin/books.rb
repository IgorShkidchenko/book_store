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
    link_to t('admin.actions.show_on_site'), book_path(book)
  end

  action_item :set_default_cover, only: :edit do
    link_to t('admin.actions.set_default_cover'), set_default_cover_admin_book_path(book), method: :put
  end

  member_action :set_default_cover, method: :put do
    book = Book.where(slug: params[:id]).last
    book.covers.update_all image: nil
    redirect_to admin_book_path(book)
  end

  after_update do
    @book.covers.create if @book.covers.empty?
  end

  after_create do
    @book.covers.create if @book.valid?
  end
end
