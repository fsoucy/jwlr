class AddSellerToDeals < ActiveRecord::Migration
  def change
    add_reference :deals, :seller, index: true, foreign_key: true
  end
end
