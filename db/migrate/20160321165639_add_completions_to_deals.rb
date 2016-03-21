class AddCompletionsToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :buyer_satisfied, :boolean
    add_column :deals, :seller_satisfied, :boolean
    add_column :deals, :product_dispatched, :boolean
  end
end
