class AddBuyerToDeals < ActiveRecord::Migration
  def change
    add_reference :deals, :buyer, index: true, foreign_key: true
  end
end
