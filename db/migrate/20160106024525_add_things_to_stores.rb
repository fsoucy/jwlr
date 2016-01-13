class AddThingsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :cover_photo, :string
    add_column :stores, :profile_photo, :string
    add_column :stores, :specialty_commodity, :string
  end
end
