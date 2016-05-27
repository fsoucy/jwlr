class Micropost < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 140 }
  belongs_to :user
  has_many :likes, as: :post, dependent: :destroy

end
