class ChangeKeyStoreToText < ActiveRecord::Migration
  def change
    change_column :key_stores, :value, :text
  end
end
