class AddCompletedToPendingDeals < ActiveRecord::Migration
  def change
    add_column :pending_deals, :completed, :boolean
  end
end
