class Blogpost < ActiveRecord::Base
  belongs_to :store
  validates :title, presence: true
  validates :content, presence: true
end
