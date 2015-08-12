class AddCompletedDealToPendingDeals < ActiveRecord::Migration
  def change
    add_column :pending_deals, :completed_deal_id, :integer
  end
end
