class RemoveUserFromSearch < ActiveRecord::Migration
  def change
    remove_column :searches, :user_id
    add_column :searches, :frequency, :integer
  end
end
