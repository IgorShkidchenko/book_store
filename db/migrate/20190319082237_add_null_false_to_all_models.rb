class AddNullFalseToAllModels < ActiveRecord::Migration[5.2]
  def change
    change_column_null :credit_cards, :number, false
    change_column_null :credit_cards, :name, false
    change_column_null :credit_cards, :expire_date, false
    change_column_null :credit_cards, :cvv, false

    change_column_null :addresses, :first_name, false
    change_column_null :addresses, :last_name, false
    change_column_null :addresses, :street, false
    change_column_null :addresses, :city, false
    change_column_null :addresses, :zip, false
    change_column_null :addresses, :country, false
    change_column_null :addresses, :phone, false
    change_column_null :addresses, :kind, false

    change_column_null :coupons, :key, false
    change_column_null :coupons, :used, false
    change_column_null :coupons, :discount, false

    change_column_null :order_items, :quantity, false

    change_column_null :orders, :aasm_state, false

    change_column_null :delivery_methods, :name, false
    change_column_null :delivery_methods, :min_days, false
    change_column_null :delivery_methods, :max_days, false
    change_column_null :delivery_methods, :cost, false

    change_column_null :reviews, :title, false
    change_column_null :reviews, :body, false
    change_column_null :reviews, :rating, false
    change_column_null :reviews, :status, false

    change_column_null :books, :title, false

    change_column_null :authors, :name, false

    change_column_null :categories, :name, false
  end
end
