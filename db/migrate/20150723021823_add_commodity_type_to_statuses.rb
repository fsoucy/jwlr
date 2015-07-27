class AddCommodityTypeToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :commodity_type, :integer
  end
end
