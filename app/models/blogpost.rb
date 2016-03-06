class Blogpost < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true
end
