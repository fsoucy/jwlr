class AddSpecificsToCompletedDeals < ActiveRecord::Migration
  def change
    add_column :completed_deals, :fulfilled_buyer, :boolean
    add_column :completed_deals, :fulfilled_seller, :boolean
    add_column :completed_deals, :complaint_buyer, :boolean
    add_column :completed_deals, :complaint_seller, :boolean
  end
end
