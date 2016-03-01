class Category < ActiveRecord::Base
  has_many :products
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category"
  has_many :category_options, dependent: :destroy
  attr_accessor :no_of_options  

  def category_options
    opts = CategoryOption.where("category_id = ?", self.id)
    if !self.parent.nil?
      if opts.nil?
        self.parent.category_options
      else
        cat_opts = opts + self.parent.category_options
      end
    else
      if opts.nil?
        Array.new
      else
        opts
      end
    end
  end

  def all_parents
    parents = []
    if !self.parent.nil?
      parents.push(self.parent)
    end
    par = self.parent
    while !par.nil?
      par = par.parent
      parents.push(par) unless par.nil?
    end
    return parents
  end

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
