class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.references :user, index: true, foreign_key: true
      t.string :search_text

      t.timestamps null: false
    end
    add_index :searches, [:user_id, :search_text], unique: true
  end
end
