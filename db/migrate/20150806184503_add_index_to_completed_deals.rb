class AddIndexToCompletedDeals < ActiveRecord::Migration
  def change
    add_index :completed_deals, :pending_deal_id, unique: true
  end
end
