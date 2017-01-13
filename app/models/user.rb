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
  #has_many :statuses, dependent: :destroy
  has_many :products, dependent: :destroy

  has_many :default_selling_method_links, dependent: :destroy
  has_many :default_exchange_method_links, dependent: :destroy
  has_many :default_payment_method_links, dependent: :destroy
  has_many :payment_upon_transaction_links
  has_many :payment_upon_transactions, through: :payment_upon_transaction_links
  
  has_many :stores, dependent: :destroy
  has_many :productviews, dependent: :destroy
  has_many :search_relationships, dependent: :destroy
  has_many :searches, through: :search_relationships
  has_many :blogposts, dependent: :destroy
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  geocoded_by :full_street_address
  after_validation :geocode
  has_many :conversations, class_name: "Conversation", foreign_key: "first_user_id", dependent: :destroy
  has_many :conversations, class_name: "Conversation", foreign_key: "second_user_id", dependent: :destroy
  #has_many :messages, class_name: "Message", foreign_key: "sender", dependent: :destroy
  has_many :buying_deals, class_name: "Deal", foreign_key: "buyer_id", dependent: :destroy
  has_many :selling_deals, class_name: "Deal", foreign_key: "seller_id", dependent: :destroy
  has_attached_file :profile_picture, :convert_options => { :medium => '-gravity center -crop 300x300+0+0', :thumb => '-gravity center -crop 200x200+0+0', :thumbnail => '-gravity center -crop 50x50+0+0', :all => '-strip -quality 100 -alpha remove -background white' }, :styles => { :medium => ["300x300^", :png], :thumb => ["200x200^", :png], :thumbnail => ["50x50^", :png] }, default_url: "/assets/missing_:style.jpg"
  validates_attachment :profile_picture, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }, :size => { :less_than => 10.megabyte }
  has_many :microposts, dependent: :destroy
  
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower   

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :shares, dependent: :destroy

  has_many :groupings, class_name: "Groupmember", foreign_key: "user_id", dependent: :destroy
  has_many :groups, through: :groupings

  has_many :saved_products, dependent: :destroy
  has_many :pictures, as: :post, dependent: :destroy
  
  searchable do
    text :name
    text :email
    text :full_street_address
    boolean :admin
    boolean :activated
    integer :id
    latlon(:location) { Sunspot::Util::Coordinates.new(self.latitude, self.longitude) }
  end

  def location_string
    address = Geocoder.search([self.latitude, self.longitude])
    address[0].city + ", " + address[0].state_code
  end

  def score
    reviews = Review.joins("INNER JOIN deals ON deals.id = reviews.deal_id").where("user_id != ? and deals.seller_id = ? or deals.buyer_id = ?", self.id, self.id, self.id)
    if reviews.count > 0
      ((reviews.select{|a| a.verdict == "Positive"}.count.to_f / reviews.count) * 100).to_i
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

  def follow(other_user)
    if other_user != self
      active_relationships.create(followed_id: other_user.id)
    end
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def like(post)
    new_like = post.likes.find_or_initialize_by(user_id: self.id)
    new_like.save
  end

  def unlike(post)
    post.likes.find_by(user_id: self.id).destroy
  end

  def likes?(post)
    !post.likes.find_by(user_id: self.id).nil?
  end

  def comment(post, comment_string)
    new_comment = post.comments.find_or_initialialize_by(user_id: self.id, comment: comment_string)
    new_comment.save
  end

  def uncomment(post, comment_id)
    post.comments.find_by(id: comment_id).destroy
  end

  private
  
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
end
