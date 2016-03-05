class CreatePictures < ActiveRecord::Migration
  def change
    drop_table :pictures
    create_table :pictures do |t|
      t.references :product, index: true, foreign_key: true
      t.attachment :photo

      t.timestamps null: false
    end
  end
end
