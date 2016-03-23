class AddFixedToBugs < ActiveRecord::Migration
  def change
    add_column :bugs, :fixed, :boolean
  end
end
