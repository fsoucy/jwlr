class AddBusinessDaysPickupToProducts < ActiveRecord::Migration
  def change
    add_column :products, :business_days_pickup, :integer
  end
end
