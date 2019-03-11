class MyOrdersPresenter < ApplicationPresenter
  attribute :params
  attribute :user, User
  attribute :orders, Order

  def chosen_filter
    filter = params[:filter]
    filter ? I18n.t("orders.filters.#{filter}") : I18n.t('orders.filters.all')
  end

  def valid_filters
    proccessing_order_states.map do |filter|
      content_tag(:li) do
        link_to t("orders.filters.#{filter}"), user_orders_path(user, filter: filter),
                class: (GOLD_TEXT if filter == params[:filter])
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

  def proccessing_order_states
    Order.aasm_states.keys.last(5)
  end

  def user_have_orders
    orders.any? || params[:filter]
  end
end
