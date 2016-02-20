class SellingMethodLink < ActiveRecord::Base
  belongs_to :product
  belongs_to :selling_method
end
