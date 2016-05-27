class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :post_id, index: true, foreign_key: true
      t.string :post_class
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :likes, [:post_id, :post_class, :user_id], unique: true
  end
end
