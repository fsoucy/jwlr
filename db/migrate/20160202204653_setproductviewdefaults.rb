class Setproductviewdefaults < ActiveRecord::Migration
  def change
    change_column :productviews, :views, :integer, :default => 1
  end
end
