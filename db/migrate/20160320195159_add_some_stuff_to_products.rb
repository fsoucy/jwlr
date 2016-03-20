class AddSomeStuffToProducts < ActiveRecord::Migration
  def change
    add_column :products, :delivery_charge, :decimal
    add_column :products, :maximum_delivery_radius_miles, :integer
  end
end
