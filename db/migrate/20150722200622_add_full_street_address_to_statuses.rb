class AddFullStreetAddressToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :full_street_address, :string
  end
end
