class ChangePicturesToPolymorphic < ActiveRecord::Migration
  def change
    rename_column :pictures, :product_id, :post_id
    add_column :pictures, :post_type, :string
    Picture.reset_column_information
    Picture.update_all(:post_type => "Product")
  end
end
