class AddIndexToDeals < ActiveRecord::Migration
  def change
    add_index :deals, :seller_id
    add_index :deals, :buyer_id
  end
  
end
