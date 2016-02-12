class AttributeOption < ActiveRecord::Base
  belongs_to :option
  has_many :toggle_options  
 
  attr_accessor :_delete
end
