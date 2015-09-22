class AddSoldToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sold, :boolean
  end
end
