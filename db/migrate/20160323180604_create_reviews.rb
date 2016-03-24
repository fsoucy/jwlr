class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :deal, index: true, foreign_key: true
      t.string :verdict
      t.string :message
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :reviews, [:deal_id, :user_id], :unique => true
  end
end
