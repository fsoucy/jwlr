

class Product < ActiveRecord::Base
  geocoded_by :full_street_address
  after_validation :geocode
  belongs_to :user
  belongs_to :store
  mount_uploader :picture, PictureUploader
  attr_accessor :hits
  has_many :pending_deals, dependent: :destroy
  has_many :productviews, dependent: :destroy

  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

  searchable do
    text :description
    text :commodity
  end
  
end
