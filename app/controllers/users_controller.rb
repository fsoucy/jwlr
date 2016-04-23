class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :selling, :buying, :completed]
  before_action :correct_user, only: [:edit, :update, :selling, :buying, :completed]
  before_action :admin_user, only: :destroy  
  
  def new
    @user = User.new
  end

  def index
    @users = User.all.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @products = Product.where("user_id = ?", @user.id)
    conversation = Conversation.where("first_user_id=? or first_user_id=? AND second_user_id=? or second_user_id=?", current_user.id, @user.id, current_user.id, @user.id)
    if conversation.first.nil?
      convo = Conversation.new(first_user_id: @user.id, second_user_id: current_user.id)
    else
      convo = conversation.first
    end
    @message = convo.messages.build(sender_id: current_user.id)
  end
  
  def create
    @user = User.new(user_params)
    @user.products_sold = 0
    @user.products_bought = 0
    @user.default_delivery_cost = 0 if @user.default_delivery_cost.nil?
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

  def edit_description
    if current_user == User.find(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to root_url
    end
  end
  
  def update
    @user = User.find(params[:id])
    if params[:selling_method_links].nil? and params[:exchange_method_links].nil? and params[:payment_method_links].nil?
      if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        render 'edit'
      end
    else
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
      flash[:success] = "Methods updated"
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
    @selling = Deal.where("seller_id=?", params[:id])
  end

  def buying
    @buying = Deal.where("buyer_id=?", params[:id])
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
      					  :password_confirmation, :public, :description, :full_street_address, :identifies_as, :interests, :profile_picture, :default_delivery_cost)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
