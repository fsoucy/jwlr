class AddStuffToStores < ActiveRecord::Migration
  def change
    add_column :stores, :tuesdaystarthour, :integer
    add_column :stores, :tuesdaystartminute, :integer
  end
end
