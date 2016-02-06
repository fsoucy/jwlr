class RemoveFrequencyFromSearches < ActiveRecord::Migration
  def change
    remove_column :searches, :frequency, :integer
  end
end
