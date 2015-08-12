class RemoveAnIndexFromPendingDeals < ActiveRecord::Migration
  def change
    remove_index :pending_deals, [:buyer_id, :seller_id]    
  end
end
