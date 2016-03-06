class PicturesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_product, only: [:new, :create, :index]
  before_action :correct_user_picture, only: [:edit, :update, :destroy]
  
  def new
    @picture = Picture.new
  end

  def create
    @picture = current_user.products.find(params[:id]).pictures.build(picture_params)
    if @picture.save
      # send success header
      render json: { message: "success", fileID: @picture.id }, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @picture.errors.full_messages.join(',')}, :status => 400
    end     
  end

  def destroy
    @picture = Picture.find(params[:id])
    if @picture.destroy    
      render json: { message: "File deleted from server" }
    else
      render json: { message: @picture.errors.full_messages.join(',') }
    end
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def update
  end

  def index
    @pictures = Product.find(params[:id]).pictures.all 
  end

  private

    def picture_params
      params.require(:picture).permit(:photo)
    end

    def correct_user_product
      product = current_user.products.find(params[:id])
      redirect_to root_url if product.nil?
    end

    def correct_user_picture
      picture = Picture.find(params[:id])
      redirect_to root_url if picture.product.user != current_user
    end

end
