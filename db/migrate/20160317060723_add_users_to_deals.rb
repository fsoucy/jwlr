class AddUsersToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :seller_id, :integer
    add_column :deals, :buyer_id, :integer
  end
end
