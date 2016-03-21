class RemoveUnnecessaryThingsFromDeals < ActiveRecord::Migration
  def change
    remove_column :deals, :buyer_location_meetup, :string
    remove_column :deals, :seller_location_meetup, :string
    remove_column :deals, :pickup_location, :string
    remove_column :deals, :location_approved, :boolean
  end
end
