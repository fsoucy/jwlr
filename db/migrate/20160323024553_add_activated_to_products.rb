class AddActivatedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :activated, :boolean
  end
end
