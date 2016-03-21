class AddMinimumPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :min_accepted_price, :decimal
  end
end
