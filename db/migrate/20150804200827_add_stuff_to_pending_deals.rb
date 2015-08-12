class AddStuffToPendingDeals < ActiveRecord::Migration
  def change
    add_column :pending_deals, :buyer_price, :float
    add_column :pending_deals, :buyer_exchange, :string
    add_column :pending_deals, :buyer_datetime, :datetime
    add_column :pending_deals, :seller_price, :float
    add_column :pending_deals, :seller_exchange, :string
    add_column :pending_deals, :seller_datetime, :datetime
  end
end
