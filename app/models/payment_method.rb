class PaymentMethod < ActiveRecord::Base
  has_many :payment_method_links
  belongs_to :deal
end
