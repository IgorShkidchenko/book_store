class CreateDeliveryMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :delivery_methods do |t|
      t.string :name
      t.integer :min_days
      t.integer :max_days
      t.float :cost

      t.timestamps
    end
  end
end
