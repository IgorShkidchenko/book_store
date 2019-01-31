class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.references :order, foreign_key: true
      t.string :key
      t.integer :discount, default: 10

      t.timestamps
    end
  end
end
