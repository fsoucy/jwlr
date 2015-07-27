class AddCommodityToProducts < ActiveRecord::Migration
  def change
    add_column :products, :commodity, :string
  end
end
