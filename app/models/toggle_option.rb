class ToggleOption < ActiveRecord::Base
  belongs_to :product
  belongs_to :attribute_option
end
