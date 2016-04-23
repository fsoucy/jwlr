class PaymentMethod < ActiveRecord::Base
  has_many :payment_method_links
  belongs_to :deal
  has_many :default_payment_method_links
end
