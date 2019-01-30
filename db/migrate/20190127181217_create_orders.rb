class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.decimal :total_price, precision: 12, scale: 3
      t.references :order_status, foreign_key: true, default: 1
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
