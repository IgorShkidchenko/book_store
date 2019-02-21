class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :aasm_state
      t.string :number
      t.references :user, foreign_key: true
      t.references :delivery_method, foreign_key: true

      t.timestamps
    end
  end
end
