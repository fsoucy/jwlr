class DefaultPaymentMethodLink < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :user
end
