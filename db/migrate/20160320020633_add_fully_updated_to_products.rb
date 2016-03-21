class AddFullyUpdatedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :fully_updated, :boolean
  end
end
