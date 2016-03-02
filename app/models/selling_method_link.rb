class SellingMethodLink < ActiveRecord::Base
  belongs_to :product
  belongs_to :selling_method

  searchable do
    integer :selling_method_id
    integer :product_id
  end
end


