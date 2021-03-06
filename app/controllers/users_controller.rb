class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :selling, :buying, :completed, :follow, :like, :comment, :share, :show, :wishlist, :save_product, :edit_description, :edit_address, :change_profile_picture, :new_picture, :pictures, :reset_password, :followers, :following]
  before_action :correct_user, only: [:edit, :update, :selling, :buying, :completed, :like, :comment, :share, :save_product, :edit_description, :edit_address, :change_profile_picture, :new_picture, :pictures, :reset_password, :followers, :following]
  before_action :admin_user, only: :destroy  
  
  def new
    @user = User.new
  end

  def index
    if !params[:search_string].present?
      @users = User.all.paginate(page: params[:page], per_page: 30)
    else
      search = User.search do
        fulltext params[:search_string] do
        end        
        with :activated, true
        order_by :score, :desc
        order_by_geodist :location, current_user.latitude, current_user.longitude
        paginate :page => params[:page], :per_page => 30
      end

      @users = search.results
    end
  end

  def new_picture
    @picture = Picture.new
  end

  def upload_picture
    if User.find(params[:id]).pictures.count < 8
      @picture = User.find(params[:id]).pictures.build(picture_params)
      if @picture.save
        render json: { message: "success", fileID: @picture.id }, :status => 200
        @picture.photo_cropped = @picture.photo
        @picture.save
        @picture.user.save
      else
        render json: { error: @picture.errors.full_messages.join(',')}, :status => 400
      end
    else
      render json: { error: "Maxiumum picture count of 8 reached" }, :status => 400
    end
  end

  def pictures
    @pictures = User.find(params[:id]).pictures.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @user = User.find(params[:id])
    @products = @user.products.where(:activated => true, :sold => false, :hold => false, :confirmed => true)
    @draft_products = @user.products.where("activated=? or confirmed=?", false, false)
    conversation = Conversation.where("first_user_id=? or first_user_id=? AND second_user_id=? or second_user_id=?", current_user.id, @user.id, current_user.id, @user.id)
    if conversation.first.nil?
      convo = Conversation.new(first_user_id: @user.id, second_user_id: current_user.id)
    else
      convo = conversation.first
    end
    @message = convo.messages.build(sender_id: current_user.id)
    @selling_reviews = Review.joins("INNER JOIN deals ON deals.id = reviews.deal_id").where("deals.seller_id = ? and user_id != ?", @user.id, @user.id).order(created_at: :desc).limit(5)
    @buying_reviews = Review.joins("INNER JOIN deals ON deals.id = reviews.deal_id").where("deals.buyer_id = ? and user_id != ?", @user.id, @user.id).order(created_at: :desc).limit(5)
  end
  
  def create
    @user = User.new(user_params)
    @user.products_sold = 0
    @user.products_bought = 0
    @user.default_delivery_cost = 0 if @user.default_delivery_cost.nil?
    @user.full_street_address = @user.address_line_1 + ", " + @user.address_line_2 + ", " + @user.city + ", " + @user.state + ", " + @user.zipcode
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def reset_password
    @user = User.find(params[:id])
  end

  def change_profile_picture
    @user = User.find(params[:id])
  end
  
  def edit_description
    if current_user == User.find(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to root_url
    end
  end

  def edit_address
    if current_user = User.find(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to root_url
    end
  end
  
  def update
    @user = User.find(params[:id])
    if params[:selling_method_links].nil? and params[:exchange_method_links].nil? and params[:payment_method_links].nil?
      if @user.update_attributes(user_params)
        @user.full_street_address = @user.address_line_1 + ", " + @user.address_line_2 + ", " + @user.city + ", " + @user.state + ", " + @user.zipcode
        @user.save
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        render 'edit'
      end
    else
      DefaultSellingMethodLink.where("user_id=?", @user.id).destroy_all
      DefaultExchangeMethodLink.where("user_id=?", @user.id).destroy_all
      DefaultPaymentMethodLink.where("user_id=?", @user.id).destroy_all
      PaymentUponTransactionLink.where("user_id=?", @user.id).destroy_all
      params[:selling_method_links].each do |method, value|
        if value["id"].to_i == 1
          DefaultSellingMethodLink.create(selling_method_id: method.to_i, user_id: @user.id)
        end
      end
      params[:exchange_method_links].each do |method, value|
        if value["id"].to_i == 1
          DefaultExchangeMethodLink.create(exchange_method_id: method.to_i, user_id: @user.id)
        end
      end
      params[:payment_method_links].each do |method, value|
        if value["id"].to_i == 1
          DefaultPaymentMethodLink.create(payment_method_id: method.to_i, user_id: @user.id)
        end
      end
      params[:payment_upon_transaction_links].each do |method, value|
        if value["id"].to_i == 1
          PaymentUponTransactionLink.create(payment_upon_transaction_id: method.to_i, user_id: @user.id)
        end
      end
      flash[:success] = "Methods updated"
      
      @user.update_attributes(user_params)
      redirect_to @user
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def edit_default_preferences
    @user = User.find_by(id: params[:id])
    @selling_methods = SellingMethod.all
    @payment_methods = PaymentMethod.all
    @exchange_methods = ExchangeMethod.all
    @transactions = PaymentUponTransaction.all
  end
  
  def user_stores
    user = User.find(params[:id])
    @has = false
    if user.stores.length > 0
      @stores = user.stores
      @has = true
    end
  end

  def selling
    @selling = Deal.where("seller_id=?", params[:id]).order(updated_at: :desc).paginate(page: params[:page], per_page: 30)
  end

  def buying
    @buying = Deal.where("buyer_id=?", params[:id]).order(updated_at: :desc).paginate(page: params[:page], per_page: 30)
  end

  def follow
    user = User.find(params[:id])
    if !user.nil?
      if current_user.following?(user)
        current_user.unfollow(user)
      else
        current_user.follow(user)
      end
      
      render json: nil, status: 200

    else
      render json: nil, status: 400
    end
  end

  def like
    post = Like.new(post_id: params[:post_id], post_type: params[:post_type]).post
    if current_user.likes?(post)
      current_user.unlike(post)
    else
      current_user.like(post)
    end

    render json: nil, status: 200
  end

  def comment
    if !params[:comment_id].nil? and params[:comment_string].nil?
      current_user.comments.find_by(id: params[:comment_id].to_i).destroy
    elsif params[:comment_id].nil?
      comment = Comment.find_or_initialize_by(post_id: params[:post_id], post_type: params[:post_type], comment: params[:comment_string], user_id: current_user.id)
      comment.save
    else
      comment = Comment.find_by(id: params[:comment_id], user_id: current_user.id)
      comment.comment = params[:comment_string]
      comment.save
    end

    render json: nil, status: 200
  end

  def share
    if !params[:share_id].nil? and params[:share_string].nil?
      current_user.shares.find_by(id: params[:share_id].to_i).destroy
    elsif params[:share_id].nil?
      share = Share.find_or_initialize_by(post_id: params[:post_id], post_type: params[:post_type], comment: params[:share_string], user_id: current_user.id)
      share.save
    else
      share = Share.find_by(id: params[:share_id], user_id: current_user.id)
      share.comment = params[:share_string]
      share.save
    end

    render json: nil, status: 200
  end

  def wishlist
    @saved_products = current_user.saved_products.all.paginate(page: params[:page], per_page: 30)
  end

  def save_product
    product = Product.find(params[:product_id])
    if product.nil?
      render json: nil, status: 400 
    else
      product = current_user.saved_products.find_by(product_id: params[:product_id])
      if product.nil?
        product = current_user.saved_products.build(product_id: params[:product_id])
        if product.save
          render json: nil, status: 200
        else
          render json: nil, status: 400
        end
      else
        product.destroy
        render json: nil, status: 200
      end
    end
  end

  def followers
    @users = current_user.followers.all.paginate(page: params[:page], per_page: 30)
  end

  def following
    @users = current_user.following.all.paginate(page: params[:page], per_page: 30)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
      					  :password_confirmation, :public, :description, :full_street_address, :identifies_as, :interests, :profile_picture, :default_delivery_cost, :acceptance_percentage, :address_line_1, :address_line_2, :city, :state, :zipcode)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
