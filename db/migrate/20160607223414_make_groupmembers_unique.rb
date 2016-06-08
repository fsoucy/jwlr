class MakeGroupmembersUnique < ActiveRecord::Migration
  def change
    add_index :groupmembers, [:user_id, :group_id], unique: true
  end
end
