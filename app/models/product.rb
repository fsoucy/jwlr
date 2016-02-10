class Product < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 255 }
  validates :category, presence: true
  geocoded_by :full_street_address
  after_validation :geocode
  belongs_to :user
  belongs_to :store
  mount_uploader :picture, PictureUploader
  attr_accessor :hits
  has_many :pending_deals, dependent: :destroy
  has_many :productviews, dependent: :destroy
  belongs_to :category

  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

  def views
    productviews.sum(:views)
  end

  searchable do
    text :description
    text :title
    
    float :price
    latlon(:location) { Sunspot::Util::Coordinates.new(self.latitude, self.longitude) }
    boolean :sold
    time :created_at    
    integer :category_id
  end
  
end
