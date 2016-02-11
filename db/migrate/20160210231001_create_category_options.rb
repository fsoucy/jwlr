class CreateCategoryOptions < ActiveRecord::Migration
  def change
    create_table :category_options do |t|
      t.references :category, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
