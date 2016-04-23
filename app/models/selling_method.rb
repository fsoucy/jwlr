class SellingMethod < ActiveRecord::Base
  has_many :selling_method_links
  has_many :default_selling_method_links
  belongs_to :deal
end
