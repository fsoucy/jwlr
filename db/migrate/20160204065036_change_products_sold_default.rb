class ChangeProductsSoldDefault < ActiveRecord::Migration
  def change
    change_column :products, :sold, :boolean, :default => false
  end
end
