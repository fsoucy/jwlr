class AddMoreandMoreStuffToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :delivery_charge, :decimal
    add_column :deals, :maximum_delivery_radius_miles, :integer
  end
end
