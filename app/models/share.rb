class Share < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  belongs_to :user

  has_many :likes, as: :post
  has_many :comments, as: :post
end
