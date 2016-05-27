class RemoveStuffFromDeals < ActiveRecord::Migration
  def change
    remove_column :deals, :reason_complaint_buye, :text
  end
end
