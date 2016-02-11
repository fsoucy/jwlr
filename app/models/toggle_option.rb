class ToggleOption < ActiveRecord::Base
  belongs_to :product
  has_one :attribute_option
end
