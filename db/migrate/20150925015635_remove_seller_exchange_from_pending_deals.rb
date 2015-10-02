class RemoveSellerExchangeFromPendingDeals < ActiveRecord::Migration
  def change
    remove_column :pending_deals, :seller_datetime, :datetime
    remove_column :pending_deals, :buyer_datetime, :datetime
    remove_column :pending_deals, :buyer_exchange, :string
    remove_column :pending_deals, :seller_exchange, :string
  end
end
