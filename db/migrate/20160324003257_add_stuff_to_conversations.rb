class AddStuffToConversations < ActiveRecord::Migration
  def change
    add_reference :conversations, :first_user, index: true, foreign_key: true
    add_reference :conversations, :second_user, index: true, foreign_key: true
    add_column :conversations, :active, :boolean
  end
end
