class HeaderPresenter < ApplicationPresenter
  def header_categories(css_class: '')
    Category.all.map do |category|
      content_tag(:li) do
        link_to category.name, category_books_path(category_id: category), class: choosen_color?(css_class, category)
      end
    end.join.html_safe
  end

  private

  def choosen_color?(css_class, category)
    user_choose_category?(category) ? (css_class + GOLD_TEXT) : css_class
  end

  def user_choose_category?(category)
    params[:category_id]&.to_i == category.id
  end
end
