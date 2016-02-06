class Search < ActiveRecord::Base
  has_many :search_relationships
  has_many :users, through: :search_relationships

  def frequency
    self.search_relationships.sum(:frequency)
  end
end
