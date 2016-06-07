class Micropost < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 140 }
  belongs_to :user
  has_many :likes, as: :post, dependent: :destroy
  has_many :comments, as: :post, dependent: :destroy  
  has_many :shares, as: :post, dependent: :destroy
  has_many :pictures, as: :post, dependent: :destroy

end
