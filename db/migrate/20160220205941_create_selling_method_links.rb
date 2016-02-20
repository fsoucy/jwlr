class CreateSellingMethodLinks < ActiveRecord::Migration
  def change
    create_table :selling_method_links do |t|
      t.integer :product_id
      t.integer :selling_method_id

      t.timestamps null: false
    end
    add_index :selling_method_links, :product_id
    add_index :selling_method_links, :selling_method_id
  end
end
