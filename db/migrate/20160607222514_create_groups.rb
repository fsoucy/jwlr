class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
