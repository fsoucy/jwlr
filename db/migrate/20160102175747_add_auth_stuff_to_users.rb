class AddAuthStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    add_column :users, :auth_expiry, :datetime
  end
end
