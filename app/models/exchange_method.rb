class ExchangeMethod < ActiveRecord::Base
  has_many :exchange_method_links
  belongs_to :deal
  has_many :default_exchange_method_links
end
