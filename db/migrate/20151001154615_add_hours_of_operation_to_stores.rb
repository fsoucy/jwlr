class AddHoursOfOperationToStores < ActiveRecord::Migration
  def change
    add_column :stores, :mondayopen, :boolean
    add_column :stores, :mondaystart, :time
    add_column :stores, :mondayend, :time
    add_column :stores, :tuesdayopen, :boolean
    add_column :stores, :tuesdaystart, :time
    add_column :stores, :tuesdayend, :time
    add_column :stores, :wednesdayopen, :boolean
    add_column :stores, :wednesdaystart, :time
    add_column :stores, :wednesdayend, :time
    add_column :stores, :thursdayopen, :boolean
    add_column :stores, :thursdaystart, :time
    add_column :stores, :thursdayend, :time
    add_column :stores, :fridayopen, :boolean
    add_column :stores, :fridaystart, :time
    add_column :stores, :fridayend, :time
    add_column :stores, :saturdayopen, :boolean
    add_column :stores, :saturdaystart, :time
    add_column :stores, :saturdayend, :time
    add_column :stores, :sundayopen, :boolean
    add_column :stores, :sundaystart, :time
    add_column :stores, :sundayend, :time
  end
end
