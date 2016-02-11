class CreateToggleOptions < ActiveRecord::Migration
  def change
    create_table :toggle_options do |t|
      t.references :product, index: true, foreign_key: true
      t.references :attribute_option, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
