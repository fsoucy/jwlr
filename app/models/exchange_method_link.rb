class ExchangeMethodLink < ActiveRecord::Base
  belongs_to :product
  belongs_to :exchange_method
  searchable do
    integer :product_id
    integer :exchange_method_id
  end
end
