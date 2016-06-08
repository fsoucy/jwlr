class PaymentUponTransactionLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_upon_transaction
end
