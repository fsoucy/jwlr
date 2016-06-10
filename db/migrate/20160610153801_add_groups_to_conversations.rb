class AddGroupsToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :group_id, :integer
    add_foreign_key :conversations, :groups
  end
end
