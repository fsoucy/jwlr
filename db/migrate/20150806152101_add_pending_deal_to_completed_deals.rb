class AddPendingDealToCompletedDeals < ActiveRecord::Migration
  def change
    add_column :completed_deals, :pending_deal_id, :integer
  end
end
