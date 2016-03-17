class DropPendingDealsAndCompletedDeals < ActiveRecord::Migration
  def change
    drop_table :pending_deals
    drop_table :completed_deals
  end
end
