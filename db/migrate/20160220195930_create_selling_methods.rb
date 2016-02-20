class CreateSellingMethods < ActiveRecord::Migration
  def change
    create_table :selling_methods do |t|
      t.string :method

      t.timestamps null: false
    end
  end
end
