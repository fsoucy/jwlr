class AddCategoryToProducts < ActiveRecord::Migration
  def change
    remove_column :products, :commodity
    add_reference :products, :category, index: true, foreign_key: true
  end
end
