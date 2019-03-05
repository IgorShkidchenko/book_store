class CatalogPresenter < Rectify::Presenter
  attribute :params
  attribute :category, Category
  attribute :categories, Category

  def chosen_filter
    filter = BooksFilterQuery::VALID_FILTERS.key(params[:filter])
    filter ? I18n.t("catalog.dropdown.#{filter}") : I18n.t('catalog.dropdown.newest')
  end

  def all_filters
    category ? filters_with_category : standart_filters
  end

  def all_books_count
    categories.sum(&:books_count)
  end

  private

  def filters_with_category
    BooksFilterQuery::VALID_FILTERS.keys.map do |filter|
      content_tag(:li) do
        link_to t("catalog.dropdown.#{filter}"),
                category_books_path(category, filter: BooksFilterQuery::VALID_FILTERS[filter], page: params[:page]),
                class: ('in-gold-500' if as_string_value(filter) == params[:filter])
      end
    end.join.html_safe
  end

  def standart_filters
    BooksFilterQuery::VALID_FILTERS.keys.map do |filter|
      content_tag(:li) do
        link_to t("catalog.dropdown.#{filter}"),
                books_path(filter: BooksFilterQuery::VALID_FILTERS[filter], page: params[:page])
      end
    end.join.html_safe
  end

  def as_string_value(filter)
    filter.to_s.tr('_', ' ')
  end
end
