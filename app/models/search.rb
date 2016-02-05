class Search < ActiveRecord::Base
  belongs_to :user

  searchable do
    text :search_text
    time :updated_at
  end
end
