class PicturesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:new, :create, :index]
  before_action :correct_user_picture, only: [:edit, :update, :destroy]
  
  def new
    @picture = Picture.new
  end
  
  def create
    if params[:post_type] == "Micropost"
      post = current_user.microposts
    elsif params[:post_type] == "User"
      post = current_user
    else
      post = current_user.products
    end

    if params[:post_type] == "User"
      if post.pictures.count < 8
        @picture = post.pictures.build(picture_params)
        if @picture.save
          render json: { message: "success", fileID: @picture.id }, :status => 200
          @picture.photo_cropped = @picture.photo
          @picture.save
          @picture.post.save
        else
          render json: { error: @picture.errors.full_messages.join(',')}, :status => 400
        end
      else
        render json: { error: "Maxiumum picture count of 8 reached" }, :status => 400
      end
    else 
      if post.find(params[:id]).pictures.count < 8
        @picture = post.find(params[:id]).pictures.build(picture_params)
        if @picture.save
          render json: { message: "success", fileID: @picture.id }, :status => 200
          @picture.photo_cropped = @picture.photo
          @picture.save
          @picture.post.save
        else
          render json: { error: @picture.errors.full_messages.join(',')}, :status => 400
        end
      else
        render json: { error: "Maxiumum picture count of 8 reached" }, :status => 400
      end
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    product = @picture.post
    if request.xhr?
      if @picture.destroy    
        render json: { message: "File deleted from server" }
      else
        render json: { message: @picture.errors.full_messages.join(',') }
      end
    else
      if @picture.destroy
        if @picture.post.class == "Product"
          @picture.post.activated = false unless @picture.post.pictures.any?
          @picture.post.save
        end
        flash[:success] = "Image deleted"
        redirect_to product
      else
        flash[:error] = @picture.errors.full_messages.join(',')
        redirect_to product
      end
    end
  end

  def edit
    @picture = Picture.find(params[:id])
    if Rails.env.production?
      img = MiniMagick::Image.open(@picture.photo.url)
    else
      img = MiniMagick::Image.open(@picture.photo.path)
    end
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
    if Rails.env.production?
      img = MiniMagick::Image.open(@picture.photo.url)
    else
      img = MiniMagick::Image.open(@picture.photo.path)
    end
    @picture.photo_cropped = @picture.photo
    @picture.save
    maxDim = img.height
    maxDim = img.width unless img.height > img.width
    scale = maxDim / 600.0
    toCropX = params[:x].to_f * scale
    toCropY = params[:y].to_f * scale
    rotation = params[:rotate].to_f
    size = "" + params[:width] + "x" + params[:height] + "+"
    cropString = size + toCropX.to_s + "+" + toCropY.to_s
    img.rotate(rotation)
    img.crop(cropString)
    @picture.photo_cropped = File.open(img.path)
    @picture.photo_cropped.reprocess!
    @picture.save
    
    if params[:main_picture] == "1"  and @picture.post.class.name == "Product"
      @picture.post.main_picture_id = @picture.id
      @picture.post.save
    end
    redirect_to @picture.post
  end

  private

    def picture_params
      params.require(:picture).permit(:photo)
    end

    def correct_user
      if params[:post_type] == "Micropost"
        post = current_user.microposts
        exist = post.exists?(params[:id])
        redirect_to root_url if !exist
      elsif params[:post_type] == "User"
        post = current_user
        exist = current_user?(User.find_by(id: params[:id]))
        redirect_to root_url if !exist
      else
        post = current_user.products
        exist = post.exists?(params[:id])
        redirect_to root_url if !exist
      end

    end

    def correct_user_picture
      picture = Picture.find(params[:id])
      redirect_to root_url if picture.post.user != current_user
    end

end
