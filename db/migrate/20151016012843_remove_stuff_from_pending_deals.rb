class RemoveStuffFromPendingDeals < ActiveRecord::Migration
  def change
    remove_column :pending_deals, :buyer_location, :string
    remove_column :pending_deals, :seller_location, :string
    remove_column :pending_deals, :seller_month, :integer
    remove_column :pending_deals, :buyer_month, :integer
    remove_column :pending_deals, :buyer_hour, :integer
    remove_column :pending_deals, :seller_hour, :integer
    remove_column :pending_deals, :seller_day, :integer
    remove_column :pending_deals, :buyer_day, :integer
    remove_column :pending_deals, :buyer_am, :boolean
    remove_column :pending_deals, :seller_am, :boolean
  end
end
