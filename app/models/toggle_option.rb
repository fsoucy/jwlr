class ToggleOption < ActiveRecord::Base
  belongs_to :product
  belongs_to :attribute_option
  searchable do
    integer :attribute_option_id
    integer :product_id
  end
end
