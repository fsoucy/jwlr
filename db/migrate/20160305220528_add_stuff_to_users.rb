class AddStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :interests, :text
    add_column :users, :products_bought, :integer
    add_column :users, :products_sold, :integer
    add_column :users, :identifies_as, :text
  end
end
