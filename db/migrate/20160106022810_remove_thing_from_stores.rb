class RemoveThingFromStores < ActiveRecord::Migration
  def change
    remove_column :stores, :picture, :string
  end
end
