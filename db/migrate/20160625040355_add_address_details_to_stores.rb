class AddAddressDetailsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :address_line_1, :string
    add_column :stores, :address_line_2, :string
    add_column :stores, :city, :string
    add_column :stores, :state, :string
    add_column :stores, :zipcode, :string
  end
end
