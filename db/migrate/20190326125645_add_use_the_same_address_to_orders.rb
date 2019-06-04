class AddUseTheSameAddressToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :use_the_same_address, :boolean, default: false
  end
end
