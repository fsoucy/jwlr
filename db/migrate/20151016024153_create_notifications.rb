class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :message
      t.boolean :read

      t.timestamps null: false
    end
  end
end
