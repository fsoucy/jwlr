class CreateExchangeMethods < ActiveRecord::Migration
  def change
    create_table :exchange_methods do |t|
      t.string :method

      t.timestamps null: false
    end
  end
end
