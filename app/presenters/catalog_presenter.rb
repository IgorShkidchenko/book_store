class CatalogPresenter < ApplicationPresenter
  attribute :params
  attribute :category, Category
  attribute :categories, Category

  def chosen_filter
    filter = Books::FilterQuery::VALID_FILTERS.key(params[:filter])
    filter ? I18n.t("catalog.dropdown.#{filter}") : I18n.t('catalog.dropdown.created_at')
  end

  def all_filters
    category ? filters_with_category : standart_filters
  end

  def all_books_count
    categories.sum(&:books_count)
  end

  private

  def filters_with_category
    Books::FilterQuery::VALID_FILTERS.keys.map do |filter|
      content_tag(:li) do
        link_to t("catalog.dropdown.#{filter}"),
                category_books_path(category, filter: Books::FilterQuery::VALID_FILTERS[filter], page: params[:page]),
                class: (GOLD_TEXT if as_string_value(filter) == params[:filter])
      end
    end.join.html_safe
  end

  def standart_filters
    Books::FilterQuery::VALID_FILTERS.keys.map do |filter|
      content_tag(:li) do
        link_to t("catalog.dropdown.#{filter}"),
                books_path(filter: Books::FilterQuery::VALID_FILTERS[filter], page: params[:page])
      end
    end.join.html_safe
  end

  def as_string_value(filter)
    filter_as_string = filter.to_s
    return filter_as_string if Books::FilterQuery::VALID_FILTERS[:created_at].eql?(filter_as_string)

    filter_as_string.tr('_', ' ')
  end
end
