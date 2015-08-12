class CreatePendingDeals < ActiveRecord::Migration
  def change
    create_table :pending_deals do |t|
      t.integer :buyer_id
      t.integer :seller_id

      t.timestamps null: false
    end
    add_index :pending_deals, :buyer_id
    add_index :pending_deals, :seller_id
    add_index :pending_deals, [:buyer_id, :seller_id], unique: true
  end
end
