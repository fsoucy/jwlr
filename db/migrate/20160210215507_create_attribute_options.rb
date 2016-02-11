class CreateAttributeOptions < ActiveRecord::Migration
  def change
    create_table :attribute_options do |t|
      t.references :category_option, index: true, foreign_key: true
      t.string :value

      t.timestamps null: false
    end
  end
end
