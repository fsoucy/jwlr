class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, polymorphic: true

  has_many :likes, as: :post, dependent: :destroy

  validates :user_id, :post_id, :post_type, :comment, presence: true
end
