class PendingDeal < ActiveRecord::Base
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User"
  belongs_to :product
  validates :product_id, presence: true
  validates :seller_id, presence: true
  validates :buyer_id, presence: true
  validate :all_in_database
  validate :buyer_seller_difference
  
  def match
    return self.buyer_price == self.seller_price && self.buyer_exchange == self.seller_exchange # && self.buyer_datetime == self.seller_datetime
  end 
 
  def all_in_database
    if !Product.exists?(product_id)
      errors.add(:product_id, "Product needs to exist")
    end
    if !User.exists?(seller_id)
      errors.add(:seller_id, "Seller needs to exist")
    end
    if !User.exists?(buyer_id)
      errors.add(:buyer_id, "Buyer needs to exist")
    end
  end

  def buyer_seller_difference
    if seller_id == buyer_id
      errors.add(:buyer_id, "Buyer can't be the same as seller")
      errors.add(:seller_id, "Seller can't be the same as buyer")
    end
  end
end
