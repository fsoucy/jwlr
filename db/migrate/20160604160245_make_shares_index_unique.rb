class MakeSharesIndexUnique < ActiveRecord::Migration
  def change
    add_index :shares, [:post_id, :post_type, :user_id], unique: true
  end
end
