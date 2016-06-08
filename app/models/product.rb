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
  has_many :pictures, as: :post, dependent: :destroy  
  has_many :selling_methods, through: :selling_method_links
  has_many :exchange_methods, through: :exchange_method_links
  has_many :payment_methods, through: :payment_method_links
  has_many :deals
  has_many :likes, as: :post, dependent: :destroy
  has_many :comments, as: :post, dependent: :destroy  

  before_save :activate
  has_many :messages

  has_many :shares, as: :post, dependent: :destroy
 
  def location_string
    address = Geocoder.search([self.latitude, self.longitude])
    address[0].city + ", " + address[0].state_code
  end

  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

  def views
    productviews.sum(:views)
  end

  def agreement_achieved
    deals.each do |deal|
      if deal.agreement_achieved
        return true
      end
    end
    return false
  end

  def buy_now
    return (static_price && (delivery || pickup))
  end

  def delivery
    exchange_methods.each do |m|
      if m.method == "Delivery"
        return true
      end
    end
    return false
  end

  def pickup
    exchange_methods.each do |m|
      if m.method == "Pickup"
        return true
      end
    end
    return false
  end

  def meetup
    exchange_methods.each do |m|
      if m.method == "Meetup"
        return true
      end
    end
    return false
  end

  def negotiation
    selling_methods.each do |m|
      if m.method == "Negotiation"
        return true
      end
    end
    return false
  end

  def static_price
    selling_methods.each do |m|
      if m.method == "Static Price"
        return true
      end
    end
    return false
  end

  def paypal
    payment_methods.each do |m|
      if m.method == "Payment"
        return true
      end
    end
    return false
  end

  def upon_transaction
    if paypal
      return payment_methods > 1
    else
      return true
    end
  end

  def only_buy_now
    #must be buy now, not have negotiation or meetup
    if buy_now
      if (meetup || negotiation)
        return false
      else
        return true
      end
    else
      return false
    end
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

  private
  
    def activate
      if self.toggle_options.count > 0 and self.selling_method_links.count > 0 and self.exchange_method_links.count > 0 and self.payment_method_links.count > 0 and self.pictures.count > 0
        self.activated = true
      else
        self.activated = false
      end
      return true
    end
end
