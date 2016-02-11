class Category < ActiveRecord::Base
  has_many :products
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category"
  has_many :category_options, dependent: :destroy
  attr_accessor :no_of_options  

  def depth
    count = 0
    current_category = self
    while !current_category.parent.nil? do
      count += 1
      current_category = current_category.parent
    end
    count
  end
end
