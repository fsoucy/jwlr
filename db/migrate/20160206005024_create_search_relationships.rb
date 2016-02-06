class CreateSearchRelationships < ActiveRecord::Migration
  def change
    create_table :search_relationships do |t|
      t.references :user, index: true, foreign_key: true
      t.references :search, index: true, foreign_key: true
      t.integer :frequency

      t.timestamps null: false
    end
    add_index :search_relationships, [:user_id, :search_id], :unique => true
  end
end
