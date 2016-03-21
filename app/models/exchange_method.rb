class ExchangeMethod < ActiveRecord::Base
  has_many :exchange_method_links
  belongs_to :deal
end
