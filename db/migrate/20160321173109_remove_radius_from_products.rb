class RemoveRadiusFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :maximum_delivery_radius_miles, :integer
  end
end
