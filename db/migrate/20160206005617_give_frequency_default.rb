class GiveFrequencyDefault < ActiveRecord::Migration
  def change
    change_column :searches, :frequency, :integer, :default => 1
    change_column :search_relationships, :frequency, :integer, :default => 1
  end
end
