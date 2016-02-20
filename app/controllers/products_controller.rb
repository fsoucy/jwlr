class ProductsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: [:destroy]  
  
  def new
    if current_user.stores.length > 0
      @has = true
      stos = Array.new
      @product = current_user.products.build
      @product.user.stores.each do |s|
        stos.push([s.name, s.id])
      end
      @stos = stos
      @default = @product.user.stores.first
    else
      @product = current_user.products.build
      @has = false
    end
	
  end
  
  def create
    if params[:store_id] != nil && store = Store.find_by(params[:store_id])
      @product = store.products.build(product_params)
      @product.full_street_address = store.full_street_address
    else
      @product = current_user.products.build(product_params)
    end
    if @product.save
      flash[:success] = "You have successfully uploaded a new product!"
      redirect_to @product
    else
      flash.now[:warning] = "Product upload failed."
      render 'new'
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    @toggle_options = @product.toggle_options
    if logged_in?
      geocode = [current_user.latitude, current_user.longitude]
    else
      geocode = [request.location.latitude, request.location.longitude]
    end
    unless geocode.nil?
      @distance_away = @product.distance_from(geocode)
    end
        
    if logged_in?
      productview = current_user.productviews.find_by(product: @product)
      if productview.nil?
        productview = current_user.productviews.build(product: @product)
      else
        productview.views += 1
      end
      productview.save
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy
    flash[:success] = "Product successfully destroyed."
    redirect_to current_user
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    params[:toggle_options].each do |attr|
      toggle_option = ToggleOption.joins('INNER JOIN "attribute_options" ON "attribute_options"."id" = "toggle_options"."attribute_option_id"').where("product_id = ? AND attribute_options.category_option_id = ?", @product.id, attr[0]).first_or_initialize
      toggle_option.update(attribute_option_id: attr[1]["name"], product_id: @product.id)
      toggle_option.save
    end
    if @product.update_attributes(product_params)
      redirect_to @product
    end
  end

  #private
  def product_params
    params.require(:product).permit(:price, :category_id, :full_street_address, :picture, :description, :store_id, :title, :toggle_option, :attribute_option_id, :color, :size)
  end
  
  def correct_user
    @product  = Product.find_by(id: params[:id])
    if !current_user.products.include?(@product)
      redirect_to root_url
    end
  end

end
