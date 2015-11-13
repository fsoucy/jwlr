class AddEvenMoreStuffToStores < ActiveRecord::Migration
  def change
    add_column :stores, :saturdaystarthour, :integer
    add_column :stores, :saturdaystartminute, :integer
    add_column :stores, :saturdaystartampm, :string
    add_column :stores, :sundaystarthour, :integer
    add_column :stores, :sundaystartminute, :integer
    add_column :stores, :sundaystartampm, :string
  end
end
