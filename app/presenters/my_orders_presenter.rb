class MyOrdersPresenter < Rectify::Presenter
  attribute :params
  attribute :user, User
  attribute :order, Order

  def chosen_filter
    filter = params[:filter]
    filter ? I18n.t("orders.filters.#{filter}") : I18n.t('orders.filters.all')
  end

  def valid_filters
    OrdersFilterQuery::VALID_FILTERS.map do |filter|
      content_tag(:li) do
        link_to t("orders.filters.#{filter}"), user_orders_path(user, filter: filter),
                class: ('in-gold-500' if filter == params[:filter])
      end
    end.join.html_safe
  end

  def no_orders_text
    return I18n.t('orders.no_orders') if orders.empty?

    I18n.t('orders.no_orders_status', status: chosen_filter)
  end

  def no_orders_link
    css_class = 'button btn btn-default mt-10'
    return link_to I18n.t('home.start_button'), books_path, class: css_class if orders.empty?

    link_to I18n.t('orders.filters.all'), user_orders_path(user), class: css_class
  end
end
