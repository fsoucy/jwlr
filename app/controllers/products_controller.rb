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
      attribute_option = AttributeOption.where("category_option_id=? AND value=?", attr[0].to_i, attr[1]["name"])
      toggle = ToggleOption.new(attribute_option_id: attribute_option[0].id, product_id: @product.id)
      ToggleOption.where("product_id=?", @product.id).each do |toggle|
        existingToggle = toggle.attribute_option.category_option_id if toggle.attribute_option.category_option_id = attr[0].to_i
      end
      if existingToggle && existingToggle.attribute_option == attribute_option[0]
        # do nothing
      else if existingToggle
        existingToggle.attribute_option_id = attribute_option[0].id
        existingToggle.save
      else
        toggle = ToggleOption.new(attribute_option_id: attribute_option[0].id, product_id: @product.id)
        toggle.save
      end
    end
    if @product.update_attributes(product_params)
      redirect_to @product
    end
  end

  private
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
