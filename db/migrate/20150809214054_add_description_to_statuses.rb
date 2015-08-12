class AddDescriptionToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :description, :text
  end
end
