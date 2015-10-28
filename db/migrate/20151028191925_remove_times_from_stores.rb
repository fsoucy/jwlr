class RemoveTimesFromStores < ActiveRecord::Migration
  def change
    remove_column :stores, :mondaystart, :time
    remove_column :stores, :mondayend, :time
    remove_column :stores, :tuesdaystart, :time
    remove_column :stores, :tuesdayend, :time
    remove_column :stores, :wednesdaystart, :time
    remove_column :stores, :wednesdayend, :time
    remove_column :stores, :thursdaystart, :time
    remove_column :stores, :thursdayend, :time
    remove_column :stores, :fridaystart, :time
    remove_column :stores, :fridayend, :time
    remove_column :stores, :saturdaystart, :time
    remove_column :stores, :saturdayend, :time
    remove_column :stores, :sundaystart, :time
    remove_column :stores, :sundayend, :time
  end
end
