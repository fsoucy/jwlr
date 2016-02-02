class CreateProductviews < ActiveRecord::Migration
  def change
    create_table :productviews do |t|
      t.references :user, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :views

      t.timestamps null: false
    end
    add_index :productviews, [:user_id, :product_id], unique: true
  end
end
