class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.integer :zip
      t.string :country
      t.integer :phone

      t.references :addressable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
