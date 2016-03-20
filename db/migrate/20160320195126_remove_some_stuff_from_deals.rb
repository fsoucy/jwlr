class RemoveSomeStuffFromDeals < ActiveRecord::Migration
  def change
    remove_column :deals, :delivery_charge, :decimal
    remove_column :deals, :maximum_delivery_radius_miles, :integer
  end
end
