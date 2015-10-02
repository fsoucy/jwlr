class AddPictureToStores < ActiveRecord::Migration
  def change
    add_column :stores, :picture, :string
  end
end
