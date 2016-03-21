class AddDeliveryCostToProducts < ActiveRecord::Migration
  def change
    add_column :products, :delivery_cost, :decimal
  end
end
