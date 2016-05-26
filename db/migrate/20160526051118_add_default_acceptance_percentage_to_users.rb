class AddDefaultAcceptancePercentageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :acceptance_percentage, :decimal
  end
end
