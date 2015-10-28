class AddMondayTimesToStores < ActiveRecord::Migration
  def change
    add_column :stores, :mondaystarthour, :integer
    add_column :stores, :mondaystartminute, :integer
    add_column :stores, :mondaystartampm, :string
  end
end
