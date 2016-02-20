class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :method

      t.timestamps null: false
    end
  end
end
