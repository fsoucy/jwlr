class RemoveDeliveryChargeFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :delivery_charge, :decimal
  end
end
