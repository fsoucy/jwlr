class ProductsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: [:destroy]  
  
  def new
    @product = current_user.products.build
    @has = false
    if @product.user.stores.length > 0
      @has = true
      stos = Array.new
      @product.user.stores.each do |s|
        stos.push([s.name, s.id])
      end
      @stos = stos
      @default = @product.user.stores.first
    end
	
  end
  
  def create
    if params[:store_id] != nil && store = Store.find_by(params[:store_id]
      @product = store.products.build(product_params)
      @product.full_street_address = Store.find(@product.store_id).full_street_address
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
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy
    flash[:success] = "Product successfully destroyed."
    redirect_to current_user
  end

  private
    def product_params
      params.require(:product).permit(:price, :commodity, :full_street_address, :picture, :description, :store_id)
    end

    def logged_in_user
      redirect_to root_url if !logged_in?
    end

    def correct_user
      @product  = Product.find_by(id: params[:id])
      if !current_user.products.include?(@product)
        redirect_to root_url
      end
    end
end
