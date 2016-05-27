class AddBuyerReasonToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :reason_complaint_buyer, :text
  end
end
