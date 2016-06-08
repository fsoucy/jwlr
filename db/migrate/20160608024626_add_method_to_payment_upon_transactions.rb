class AddMethodToPaymentUponTransactions < ActiveRecord::Migration
  def change
    add_column :payment_upon_transactions, :method, :string
  end
end
