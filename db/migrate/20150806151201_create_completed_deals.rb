class CreateCompletedDeals < ActiveRecord::Migration
  def change
    create_table :completed_deals do |t|
      t.float :price
      t.string :exchange
      t.string :location
      t.string :commodity
      t.integer :seller_id
      t.integer :buyer_id
      t.boolean :fulfilled
      t.integer :complaint_id

      t.timestamps null: false
    end
  end
end
