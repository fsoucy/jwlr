class PaymentMethodLink < ActiveRecord::Base
  belongs_to :product
  belongs_to :payment_method
end
