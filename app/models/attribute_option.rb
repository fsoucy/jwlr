class AttributeOption < ActiveRecord::Base
  belongs_to :option
  
  attr_accessor :_delete
end
