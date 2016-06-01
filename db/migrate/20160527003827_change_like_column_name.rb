class ChangeLikeColumnName < ActiveRecord::Migration
  def change
    rename_column :likes, :post_class, :post_type
  end
end
