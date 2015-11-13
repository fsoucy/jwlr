class AddEndStuffToStores < ActiveRecord::Migration
  def change
    add_column :stores, :mondayendhour, :integer
    add_column :stores, :mondayendminute, :integer
    add_column :stores, :mondayendampm, :string
    add_column :stores, :tuesdayendhour, :integer
    add_column :stores, :tuesdayendminute, :integer
    add_column :stores, :tuesdayendampm, :string
    add_column :stores, :wednesdayendhour, :integer
    add_column :stores, :wednesdayendminute, :integer
    add_column :stores, :wednesdayendampm, :string
    add_column :stores, :thursdayendhour, :integer
    add_column :stores, :thursdayendminute, :integer
    add_column :stores, :thursdayendampm, :string
    add_column :stores, :fridayendhour, :integer
    add_column :stores, :fridayendminute, :integer
    add_column :stores, :fridayendampm, :string
    add_column :stores, :saturdayendhour, :integer
    add_column :stores, :saturdayendminute, :integer
    add_column :stores, :saturdayendampm, :string
    add_column :stores, :sundayendhour, :integer
    add_column :stores, :sundayendminute, :integer
    add_column :stores, :sundayendampm, :string
  end
end
