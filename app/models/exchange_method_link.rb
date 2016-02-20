class ExchangeMethodLink < ActiveRecord::Base
  belongs_to :product
  belongs_to :exchange_method
end
