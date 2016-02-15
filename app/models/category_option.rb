class CategoryOption < ActiveRecord::Base
  belongs_to :category
  has_many :attribute_options, dependent: :destroy
  
  attr_accessor :no_of_options
  attr_accessor :_delete

  searchable do
    integer :category_id
  end
end
