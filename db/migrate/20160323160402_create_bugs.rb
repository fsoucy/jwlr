class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.text :title
      t.text :content
      t.string :url

      t.timestamps null: false
    end
  end
end
