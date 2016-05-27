class Blogpost < ActiveRecord::Base
  belongs_to :store
  belongs_to :user

  has_many :likes, as: :post, dependent: :destroy  

  validates :title, presence: true
  validates :content, presence: true


end
