class HeaderPresenter < Rectify::Presenter
  attribute :categories, Category

  def header_categories(css_class: '')
    categories.map do |category|
      content_tag(:li) do
        link_to category.name, category_books_path(category_id: category), class: css_class
      end
    end.join.html_safe
  end
end
