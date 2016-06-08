class CreatePaymentUponTransactionLinks < ActiveRecord::Migration
  def change
    create_table :payment_upon_transaction_links do |t|
      t.references :user, index: true, foreign_key: true
      t.references :payment_upon_transaction, foreign_key: true

      t.timestamps null: false
    end
  end
end
