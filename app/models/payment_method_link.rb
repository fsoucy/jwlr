class PaymentMethodLink < ActiveRecord::Base
  belongs_to :product
  belongs_to :payment_method
  searchable do
    integer :product_id
    integer :payment_method_id
  end
end
