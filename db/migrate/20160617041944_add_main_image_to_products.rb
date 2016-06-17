class AddMainImageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :main_picture_id, :integer
  end
end
