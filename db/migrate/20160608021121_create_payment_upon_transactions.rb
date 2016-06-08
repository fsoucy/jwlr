class CreatePaymentUponTransactions < ActiveRecord::Migration
  def change
    create_table :payment_upon_transactions do |t|

      t.timestamps null: false
    end
  end
end
