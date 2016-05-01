class CreateKeyStores < ActiveRecord::Migration
  def change
    create_table :key_stores do |t|
      t.string :key
      t.string :value

      t.timestamps null: false
    end
    add_index :key_stores, :key, :unique => true
  end
end
