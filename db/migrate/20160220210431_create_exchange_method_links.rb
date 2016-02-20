class CreateExchangeMethodLinks < ActiveRecord::Migration
  def change
    create_table :exchange_method_links do |t|
      t.integer :product_id
      t.integer :exchange_method_id

      t.timestamps null: false
    end
    add_index :exchange_method_links, :product_id
    add_index :exchange_method_links, :exchange_method_id
  end
end
