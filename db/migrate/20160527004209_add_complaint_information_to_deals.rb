class AddComplaintInformationToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :reason_complaint_seller, :text
    add_column :deals, :reason_complaint_buye, :text
  end
end
