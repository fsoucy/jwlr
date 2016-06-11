class RemoveUsersFromPictures < ActiveRecord::Migration
  def change
    remove_reference :pictures, :user, index: true, foreign_key: true
  end
end
