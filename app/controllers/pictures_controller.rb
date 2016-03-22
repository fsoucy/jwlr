class PicturesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_product, only: [:new, :create, :index]
  before_action :correct_user_picture, only: [:edit, :update, :destroy]
  
  def new
    @picture = Picture.new
  end

  def create
    if current_user.products.find(params[:id]).pictures.count < 8
    @picture = current_user.products.find(params[:id]).pictures.build(picture_params)
      if @picture.save
        render json: { message: "success", fileID: @picture.id }, :status => 200
      else
        render json: { error: @picture.errors.full_messages.join(',')}, :status => 400
      end
    else
      render json: { error: "Maxiumum picture count of 8 reached" }, :status => 400
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
    img = MiniMagick::Image.open(@picture.photo.path)
    maxDim = img.height
    maxDim = img.width unless img.height > img.width
    @factor = 600.0 / maxDim
  end

  def update
  end

  def index
    @pictures = Product.find(params[:id]).pictures.all 
  end

  def add_cropped
    @picture = Picture.find(params[:id])
    img = MiniMagick::Image.open(@picture.photo.path)
    @picture.photo_cropped = @picture.photo
    @picture.save
    maxDim = img.height
    maxDim = img.width unless img.height > img.width
    scale = maxDim / 600.0
    toCropX = params[:x].to_f * scale
    toCropY = params[:y].to_f * scale
    size = "" + params[:width] + "x" + params[:height] + "+"
    cropString = size + toCropX.to_s + "+" + toCropY.to_s
    img.crop(cropString)
    img.write(@picture.photo_cropped.path)
    @picture.photo_cropped.reprocess!
    @picture.save
    redirect_to @picture.product
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
