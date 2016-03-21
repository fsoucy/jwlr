class AddBoolToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :deal_complete, :boolean
    add_column :deals, :payment_complete, :boolean
    add_column :deals, :product_received, :boolean
  end
end
