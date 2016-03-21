class RemoveBusinessDaysPickupFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :business_days_pickup, :integer
  end
end
