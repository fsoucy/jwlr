class AddCommodityToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :commodity, :string
  end
end
