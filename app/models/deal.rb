class Deal < ActiveRecord::Base
  has_one :payment_method
  has_one :selling_method
  has_one :exchange_method
  belongs_to :product
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User"
end
