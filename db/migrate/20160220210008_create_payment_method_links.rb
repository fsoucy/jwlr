class CreatePaymentMethodLinks < ActiveRecord::Migration
  def change
    create_table :payment_method_links do |t|
      t.integer :product_id
      t.integer :payment_method_id

      t.timestamps null: false
    end
    add_index :payment_method_links, :product_id
    add_index :payment_method_links, :payment_method_id
  end
end
