class RemoveCommodityTypeFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :commodity_type, :integer
  end
end
