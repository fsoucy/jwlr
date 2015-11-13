class AddMoreStuffToStores < ActiveRecord::Migration
  def change
    add_column :stores, :tuesdaystartampm, :string
    add_column :stores, :wednesdaystarthour, :integer
    add_column :stores, :wednesdaystartminute, :integer
    add_column :stores, :wednesdaystartampm, :string
    add_column :stores, :thursdaystarthour, :integer
    add_column :stores, :thursdaystartminute, :integer
    add_column :stores, :thursdaystartampm, :string
    add_column :stores, :fridaystarthour, :integer
    add_column :stores, :fridaystartminute, :integer
    add_column :stores, :fridaystartampm, :string
  end
end
