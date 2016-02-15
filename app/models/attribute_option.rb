class AttributeOption < ActiveRecord::Base
  belongs_to :category_option
  has_many :toggle_options
 
  attr_accessor :_delete
end
