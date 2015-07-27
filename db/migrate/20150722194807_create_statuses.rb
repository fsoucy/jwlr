class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :minPrice
      t.integer :maxPrice
      t.boolean :buying
      t.float :latitude
      t.float :longitude
      t.integer :toTravel

      t.timestamps null: false
    end
  end
end
