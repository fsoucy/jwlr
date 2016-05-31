class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :post, polymorphic: true, index: true
      t.string :comment

      t.timestamps null: false
    end
  end
end
