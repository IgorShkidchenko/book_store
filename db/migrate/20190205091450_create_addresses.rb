class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :street
      t.string :city
      t.integer :zip
      t.string :country
      t.string :phone
      t.string :kind

      t.references :addressable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
