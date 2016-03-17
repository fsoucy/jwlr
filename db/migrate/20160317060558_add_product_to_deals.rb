class AddProductToDeals < ActiveRecord::Migration
  def change
    add_reference :deals, :product, index: true, foreign_key: true
  end
end
