class Status < ActiveRecord::Base
  belongs_to :user
  geocoded_by :full_street_address
  after_validation :geocode
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :minPrice, presence: true
  validates :maxPrice, presence: true
  validates :toTravel, presence: true

  def matching_products
    near_products = Product.near([self.latitude, self.longitude],
    	       				    self.toTravel)
    products_price = Array.new
    near_products.each { |p| products_price.push(p) if p.price >= self.minPrice && p.price <= self.maxPrice }
    products = Array.new
    products_price.each { |p| products.push(p) if p.commodity == self.commodity }
    self.match_for_all_desc(products)
  end
  
  def match_for_all_desc(products)
    products.each { |product| self.match_for_desc(product) }
    products = products.sort_by { |p| p.hits }
    products
  end

  def match_for_desc(product)
    productDesc = product.description.split(" ")
    statusDesc = self.description.split(" ")
    product.hits = 0
    statusDesc.each do |s|
      productDesc.each do |p|
        if s == p
	  product.hits = product.hits + 1
	end
      end
    end
  end
end
