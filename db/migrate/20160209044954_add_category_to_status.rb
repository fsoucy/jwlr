class AddCategoryToStatus < ActiveRecord::Migration
  def change
    remove_column :statuses, :commodity
    add_reference :statuses, :category, index: true, foreign_key: true
  end
end
