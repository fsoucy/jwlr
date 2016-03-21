class AddBusinessDaysPickupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :business_days_pickup, :integer
  end
end
