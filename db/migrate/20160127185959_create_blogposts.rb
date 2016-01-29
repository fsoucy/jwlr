class CreateBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.text :title
      t.text :content
      t.references :store, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
