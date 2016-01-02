class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :selling, :buying, :completed]
  before_action :correct_user, only: [:edit, :update, :selling, :buying, :completed]
  before_action :admin_user, only: :destroy  
  
  def new
    @user = User.new
  end

  def index
    @users = User.where(public: true).paginate(page: params[:page])
  end

  
  def show
    @user = User.find(params[:id])
    @products = Product.where("user_id = ?", @user.id)
    @gold_coins = Product.where("user_id = ? AND commodity = ?", @user.id, "Gold Coins")
    @jewelry = Product.where("user_id = ? AND commodity = ?", @user.id, "Jewelry")
    @gold_bricks = Product.where("user_id = ? AND commodity = ?", @user.id, "Gold Bricks")
    @precious_stones = Product.where("user_id = ? AND commodity = ?", @user.id, "Precious Stones")
  end
  
  def sign_in_mobile
    if request.post? %% request.headers["Content-Type"] == "application/json"
      if params && params[:email] && params[:password]
        user = User.find_by(params[:email])
	if user
	  if user.authenticate(params[:password])
	    user.auth_token = User.new_token
	    user.auth_expiry = Time.now + 24 * 60 * 60
	    if user.save
	      render json: user.to_json, status: 200
	    end
	  else
	    e = Error.new(status: 401, message: "Wrong password")
	    render json: e.to_json, status: 401
	  end
	else
	  e = Error.new(status: 400, message: "User with that email not found")
	  render json: e.to_json, status: 400
	end
      else
        e = Error.new(status: 400, message: "Parameters missing")
	render json: e.to_json, status: 400
      end
    end
  end
    
  def create
    if request.headers["Content-Type"] == "application/json"
      if params && params[:name] && params[:email] && params[:password] && params[:password_confirmation] && params[:public] && params[:description]
        params[:user] = Hash.new
	params[:user][:name] = params[:name]
	params[:user][:email] = params[:email]
	params[:user][:password] = params[:password]
	params[:user][:password_confirmation] = params[:password_confirmation]
	params[:user][:public] = params[:public]
	params[:user][:description] = params[:description]
	user = User.new(user_params)
	if user.save
	  user.send_activation_email
	  render :json => user.to_json, :status => 200
	else
	  error_str = ""
	  user.errors.each{|attr, msg|
	    error_str += "#{attr} - #{msg}, "
	  }
	  e = Error.new(status: 400, message: error_str)
	  render :json => e.to_json, :status => 400
	end
      else
        e = Error.new(status: 400, message: "parameters missing")
	render :json => e.to_json, :status => 400
      end
    else        	  
      @user = User.new(user_params)
      if @user.save
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url
      else
        render 'new'
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_description
    if current_user == User.find(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to root_url
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def selling
    @deals = User.find(params[:id]).selling_feed
  end

  def buying
    @deals = User.find(params[:id]).buying_feed
  end

  def completed
    user = User.find(params[:id])
    @deals = user.active_completed_deals + user.passive_completed_deals
  end

  def user_stores
    user = User.find(params[:id])
    @has = false
    if user.stores.length > 0
      @stores = user.stores
      @has = true
    end
  end

  def noties
    @notes = User.find(params[:id]).notifications
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
      					  :password_confirmation, :public, :description)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
	redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
