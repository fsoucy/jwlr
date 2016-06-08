class PaymentUponTransaction < ActiveRecord::Base
  has_many :payment_upon_transaction_links
end
