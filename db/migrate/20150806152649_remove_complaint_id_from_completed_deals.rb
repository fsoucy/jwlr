class RemoveComplaintIdFromCompletedDeals < ActiveRecord::Migration
  def change
    remove_column :completed_deals, :complaint_id, :integer
  end
end
