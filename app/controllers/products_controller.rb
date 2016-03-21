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
      @product.business_days_pickup = current_user.business_days_pickup
    else
      @product = current_user.products.build(product_params)
      @product.full_street_address = current_user.full_street_address
      @product.business_days_pickup = current_user.business_days_pickup
    end
    if @product.save
      flash[:success] = "You have successfully uploaded a new product!"
      redirect_to edit_toggle_options_product_path(@product.id)
    else
      flash.now[:warning] = "Product upload failed."
      render 'new'
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    @deal = current_user.buying_deals.build(seller_id: @product.user.id, product_id: @product.id)
    @current_user = current_user
    @toggle_options = @product.toggle_options
    search = Sunspot.more_like_this(@product) do
      fields :description, :title
      boost_by_relevance true
      paginate :page => 1, :per_page => 5
    end
    @more_like_this = search.results
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

  def edit_toggle_options
    @product = Product.find(params[:id])
  end

  def edit_selling_methods
    @product = Product.find(params[:id])
    @selling_methods = SellingMethod.all
  end

  def edit_payment_methods
    @product = Product.find(params[:id])
    @payment_methods = PaymentMethod.all
  end

  def edit_exchange_methods
    @product = Product.find(params[:id])
    @exchange_methods = ExchangeMethod.all
  end

  def update
    @product = Product.find(params[:id])
    toggle_options = params[:toggle_options]
    selling_methods = params[:selling_method_links]
    exchange_methods = params[:exchange_method_links]
    payment_methods = params[:payment_method_links]
    picture = params[:picture]

    
    unless toggle_options.nil?
      toggle_options.each do |attr|
        toggle_option = ToggleOption.joins('INNER JOIN "attribute_options" ON "attribute_options"."id" = "toggle_options"."attribute_option_id"').where("product_id = ? AND attribute_options.category_option_id = ?", @product.id, attr[0]).first_or_initialize
        toggle_option.update(attribute_option_id: attr[1]["name"], product_id: @product.id)
        toggle_option.save
      end
      redirect_to edit_selling_methods_product_path(@product.id)
      return
    end

    unless selling_methods.nil?
      @product.selling_method_links.each do |l|
        l.destroy
      end
      selling_methods.each do |id, selected|
        @product.selling_method_links.build(selling_method_id: id).save if selected["id"].to_i == 1
      end
      redirect_to edit_exchange_methods_product_path(@product.id)
      return
      #redirect_to controller: 'ProductsController', action: 'edit_exchange_methods', id: @product.id
    end

    unless exchange_methods.nil?
      @product.exchange_method_links.each do |l|
        l.destroy
      end
      exchange_methods.each do |id, selected|
        @product.exchange_method_links.build(exchange_method_id: id).save if selected["id"].to_i == 1
      end
      redirect_to edit_payment_methods_product_path(@product.id)
      return
    end

    unless payment_methods.nil?
      @product.payment_method_links.each do |l|
        l.destroy
      end
      payment_methods.each do |id, selected|
        @product.payment_method_links.build(payment_method_id: id).save if selected["id"].to_i == 1
      end
      redirect_to new_picture_url
      return
    end

    if !picture.nil?
      if @product.min_accepted_price.nil?
        @product.min_accepted_price = 0.0
      end
      @product.save
    end

    unless product_params.nil?
      if @product.update_attributes(product_params)
        redirect_to edit_toggle_options_product_path(@product.id)
      end
    end
  end

  private
  def product_params
    params.require(:product).permit(:price, :category_id, :full_street_address, :picture, :description, :store_id, :title, :min_accepted_price, :delivery_charge, :maximum_delivery_radius_miles)
  end
  
  def correct_user
    @product  = Product.find_by(id: params[:id])
    if !current_user.products.include?(@product)
      redirect_to root_url
    end
  end

end
