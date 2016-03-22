class SetDefaultHoldValue < ActiveRecord::Migration
  def change
    change_column :products, :sold, :boolean, :default => false
    change_column :products, :hold, :boolean, :default => false
  end
end
