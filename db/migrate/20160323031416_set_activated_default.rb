class SetActivatedDefault < ActiveRecord::Migration
  def change
    change_column :products, :activated, :boolean, :default => false
  end
end
