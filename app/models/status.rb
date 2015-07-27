class Status < ActiveRecord::Base
  belongs_to :user
  geocoded_by :full_street_address
  after_validation :geocode
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :minPrice, presence: true
  validates :maxPrice, presence: true
  validates :toTravel, presence: true
end
