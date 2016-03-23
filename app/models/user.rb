class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  	    	    format: { with: VALID_EMAIL_REGEX },
		    uniqueness: { case_sensitive: false }
  validates :full_street_address, presence: true
  has_secure_password
  has_many :notifications, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :stores, dependent: :destroy
  has_many :active_deals, class_name: "PendingDeal", foreign_key: "buyer_id",
  	   		  	      dependent: :destroy
  has_many :passive_deals, class_name: "PendingDeal",
  	   		foreign_key: "seller_id", dependent: :destroy
  has_many :active_completed_deals, class_name: "CompletedDeal", foreign_key: "buyer_id",
  	   			    		dependent: :destroy
  has_many :passive_completed_deals, class_name: "CompletedDeal", foreign_key: "seller_id",
  	   			     		 dependent: :destroy
  has_many :productviews, dependent: :destroy
  has_many :search_relationships, dependent: :destroy
  has_many :searches, through: :search_relationships
  has_many :blogposts, dependent: :destroy
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  geocoded_by :full_street_address
  after_validation :geocode
  has_many :buying_deals, class_name: "Deal", foreign_key: "buyer_id", dependent: :destroy
  has_many :selling_deals, class_name: "Deal", foreign_key: "seller_id", dependent: :destroy
  mount_uploader :profile_picture, PictureUploader
  has_many :reviews

  def score
    reviews = Review.joins("INNER JOIN deals ON deals.id = reviews.deal_id").where("user_id != ? and deals.seller_id = ? or deals.buyer_id = ?", self.id, self.id, self.id)
    if reviews.count > 0
      (reviews.select{|a| a.verdict == "Positive"}.count / reviews.count) * 100
    else
      return 0
    end
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    	   					  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(self.reset_token), reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  
  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at, :password_digest, :remember_digest, :activation_digest, :activated_at, :reset_digest, :reset_sent_at]
    super(options)
  end

    #hi
  private
  
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
end
