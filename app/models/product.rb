class Product < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 255 }
  validates :category, presence: true
  validates :full_street_address, presence: true
  validates :price, presence: true, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => { :greater_than => 0 }
  validates :description, presence: true 
  geocoded_by :full_street_address
  after_validation :geocode
  belongs_to :user
  belongs_to :store
  attr_accessor :hits
  has_many :productviews, dependent: :destroy
  belongs_to :category
  has_many :toggle_options, dependent: :destroy
  has_many :exchange_method_links, dependent: :destroy
  has_many :payment_method_links, dependent: :destroy
  has_many :selling_method_links, dependent: :destroy
  has_many :pictures, dependent: :destroy  
  has_many :deals
  
  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

  def views
    productviews.sum(:views)
  end

  searchable do
    text :description, :more_like_this => true
    text :title, :more_like_this => true
    integer :id
    join(:attribute_option_id, :target => ToggleOption, :type => :integer, :join => { :from => :product_id, :to => :id })
    join(:selling_method_id, :target => SellingMethodLink, :type => :integer, :join => { :from => :product_id, :to => :id })
    join(:payment_method_id, :target => PaymentMethodLink, :type => :integer, :join => { :from => :product_id, :to => :id })
    join(:exchange_method_id, :target => ExchangeMethodLink, :type => :integer, :join => { :from => :product_id, :to => :id })
    references :selling_method_id
    references :payment_method_id
    references :exchange_method_id
    references :attribute_option_id
    float :price
    latlon(:location) { Sunspot::Util::Coordinates.new(self.latitude, self.longitude) }
    boolean :sold
    boolean :hold
    boolean :activated
    time :created_at    
    integer :category_id
  end
  
end
