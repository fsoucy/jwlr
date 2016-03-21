class AddDefaultDeliveryCostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_delivery_cost, :decimal
  end
end
