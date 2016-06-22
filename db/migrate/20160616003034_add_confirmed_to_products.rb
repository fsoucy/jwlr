class AddConfirmedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :confirmed, :boolean
  end
end
