class AddPeripheralsToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :buyer_location_meetup, :string
    add_column :deals, :seller_location_meetup, :string
    add_column :deals, :pickup_location, :string
    add_column :deals, :dropoff, :string
    add_column :deals, :location_approved, :boolean
    add_column :deals, :user_proposed_price, :decimal
    add_column :deals, :agreement_achieved, :boolean
    add_column :deals, :proposed_price_accepted, :boolean
  end
end
