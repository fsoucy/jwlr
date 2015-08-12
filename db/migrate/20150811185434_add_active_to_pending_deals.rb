class AddActiveToPendingDeals < ActiveRecord::Migration
  def change
    add_column :pending_deals, :active, :boolean
  end
end
