class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :permalink
      t.text :description
      t.integer :price
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :products, :users
  end
end
