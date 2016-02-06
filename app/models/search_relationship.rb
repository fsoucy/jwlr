class SearchRelationship < ActiveRecord::Base
  attr_accessor :search_text
  belongs_to :user
  belongs_to :search

  before_create :associate_with_search

  private
    
    def associate_with_search
      search = Search.find_or_initialize_by(search_text: :search_text)
      search.save
      self.search_id = search.id
      self.save
    end
end
