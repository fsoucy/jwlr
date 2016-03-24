class UsePaperclipForStores < ActiveRecord::Migration
  def change
    remove_column :stores, :profile_photo
    add_attachment :stores, :profile_picture
  end
end
