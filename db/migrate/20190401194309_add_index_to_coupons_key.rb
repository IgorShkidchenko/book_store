class AddIndexToCouponsKey < ActiveRecord::Migration[5.2]
  def change
    add_index :coupons, :key, unique: true
  end
end
