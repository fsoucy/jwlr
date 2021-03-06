class AddProductToPendingDeal < ActiveRecord::Migration
  def change
    add_column :pending_deals, :product_id, :integer
    add_index :pending_deals, :product_id
    add_index :pending_deals, [:product_id, :seller_id, :buyer_id],
    	       		       unique: true
  end
end
