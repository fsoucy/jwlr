class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.references :post, polymorphic: true, index: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
