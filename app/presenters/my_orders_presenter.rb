class MyOrdersPresenter < Rectify::Presenter
  attribute :params
  attribute :user, User
  attribute :orders, Order

  def chosen_filter
    filter = params[:filter]
    filter ? I18n.t("orders.filters.#{filter}") : I18n.t('orders.filters.all')
  end

  def valid_filters
    filters_as_string.map do |filter|
      content_tag(:li) do
        link_to t("orders.filters.#{filter}"), user_orders_path(user, filter: filter),
                class: ('in-gold-500' if filter == params[:filter])
      end
    end.join.html_safe
  end

  def no_orders_text
    return I18n.t('orders.no_orders') unless user_have_orders

    I18n.t('orders.no_orders_status', status: chosen_filter)
  end

  def no_orders_link
    css_class = 'button btn btn-default mt-10'
    return link_to I18n.t('home.start_button'), books_path, class: css_class unless user_have_orders

    link_to I18n.t('orders.filters.all'), user_orders_path(user), class: css_class
  end

  private

  def filters_as_string
    Order::STATUSES[:processing].keys.map(&:to_s)
  end

  def user_have_orders
    orders.any? || params[:filter]
  end
end
