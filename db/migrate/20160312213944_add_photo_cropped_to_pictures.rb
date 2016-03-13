class AddPhotoCroppedToPictures < ActiveRecord::Migration
  def change
    add_attachment :pictures, :photo_cropped
  end
end
