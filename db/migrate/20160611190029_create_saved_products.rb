class CreateSavedProducts < ActiveRecord::Migration
  def change
    create_table :saved_products do |t|
      t.references :user, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :saved_products, [:user_id, :product_id], unique: true
  end
end
