class RemoveSellerAndBuyerFromDeals < ActiveRecord::Migration
  def change
    remove_reference :deals, :seller, index: true, foreign_key: true
    remove_reference :deals, :buyer, index: true, foreign_key: true
  end
end
