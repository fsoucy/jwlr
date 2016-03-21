class Deal < ActiveRecord::Base
  belongs_to :product
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User"
  belongs_to :selling_method
  belongs_to :exchange_method
  belongs_to :payment_method
end
