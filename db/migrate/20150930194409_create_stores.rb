class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :full_street_address
      t.string :name
      t.integer :business_days_pickup
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
