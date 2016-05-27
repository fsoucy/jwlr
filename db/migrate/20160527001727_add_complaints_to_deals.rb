class AddComplaintsToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :complaint_buyer, :boolean
    add_column :deals, :complaint_seller, :boolean
  end
end
