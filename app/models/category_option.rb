class CategoryOption < ActiveRecord::Base
  belongs_to :category
  has_many :attribute_options
  
  attr_accessor :no_of_options
  attr_accessor :_delete  

  accepts_nested_attributes_for :attribute_options
end
