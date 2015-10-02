class AddThingsToPendingDeals < ActiveRecord::Migration
  def change
    add_column :pending_deals, :exchange_public_seller, :boolean
    add_column :pending_deals, :exchange_public_buyer, :boolean
    add_column :pending_deals, :seller_location, :string
    add_column :pending_deals, :buyer_location, :string
    add_column :pending_deals, :buyer_hour, :integer
    add_column :pending_deals, :seller_hour, :integer
    add_column :pending_deals, :buyer_month, :integer
    add_column :pending_deals, :seller_month, :integer
    add_column :pending_deals, :buyer_day, :integer
    add_column :pending_deals, :seller_day, :integer
    add_column :pending_deals, :seller_am, :boolean
    add_column :pending_deals, :buyer_am, :boolean
  end
end
