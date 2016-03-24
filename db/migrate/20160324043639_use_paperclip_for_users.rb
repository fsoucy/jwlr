class UsePaperclipForUsers < ActiveRecord::Migration
  def change
    remove_column :users, :profile_picture
    add_attachment :users, :profile_picture
  end
end
