class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.float :price
      t.text :description
      t.integer :published_year
      t.float :height
      t.float :width
      t.float :depth
      t.string :materials
      t.string :slug
      t.references :category, foreign_key: true

      t.timestamps
    end
    add_index :books, :slug, unique: true
  end
end
