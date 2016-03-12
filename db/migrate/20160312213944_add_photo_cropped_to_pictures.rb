class AddPhotoCroppedToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :photo_cropped, :attachment
  end
end
