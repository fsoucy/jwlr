class RemoveCommodityTypeFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :commodity_type, :integer
  end
end
