class AddHoldToProducts < ActiveRecord::Migration
  def change
    add_column :products, :hold, :boolean
  end
end
