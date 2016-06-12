class ProductsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: [:destroy]
  after_action :pickup, only: [:create, :update]
  
  def new
    @edit = false
    @selling_methods = SellingMethod.all
    @payment_methods = PaymentMethod.all
    @exchange_methods = ExchangeMethod.all
    @product = current_user.products.build
    @categories = []
    Category.all.each do |cat|
      if cat.children.count == 0
        # do nothing
      else
        @categories.append(cat)
      end
    end
    @picture = Picture.new
    @product_activated = 0
    @has_picture = @product.pictures.count
    if current_user.stores.length > 0
      @has = true
      stos = Array.new
      @product.user.stores.each do |s|
        stos.push([s.name, s.id])
      end
      stos.push(["None", "nil"])
      @stos = stos
      @default = @product.user.stores.first
    else
      @has = false
    end
    @product.save(validate: false)
  end
  
  def show
    @product = Product.find_by(id: params[:id])
    if (!@product.activated and @product.user.id == current_user.id)
      flash[:warning] = "Product not yet activated; you have remaining fields to fill out"
      redirect_to edit_product_path(@product)
      return
    end

    if (!@product.activated and @product.user.id != current_user.id)
      redirect_to @product.user
      return
    end

    @buy_now = @product.buy_now
    @only_buy_now = @product.only_buy_now
    @delivery = false
    
    
    if logged_in?
      @deal = current_user.buying_deals.build(seller_id: @product.user.id, product_id: @product.id)
      @current_user = current_user

      if !current_user?(@product.user)
        conversation = Conversation.where("first_user_id=? or first_user_id=? AND second_user_id=? or second_user_id=?", current_user.id, @product.user.id, current_user.id, @product.user.id)
        if conversation.first.nil?
          convo = Conversation.new(first_user_id: @product.user.id, second_user_id: current_user.id)
        else
          convo = conversation.first
        end
        @message = convo.messages.build(sender_id: current_user.id, product_id: @product.id)
      end
    end
    @toggle_options = @product.toggle_options
    search = Sunspot.more_like_this(@product) do
      fields :description, :title
      with(:sold, false)
      with(:hold, false)
      with :activated, true
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
    if !@product.sold
      @product.destroy
      flash[:success] = "Product successfully destroyed."
      redirect_to current_user
    else
      redirect_to @product
    end
  end

  def edit
    @picture = Picture.new
    @edit = true
    @selling_methods = SellingMethod.all
    @payment_methods = PaymentMethod.all
    @exchange_methods = ExchangeMethod.all
    @product = Product.find(params[:id])
    @has_picture = @product.pictures.count
    @categories = []
    Category.all.each do |cat|
      if cat.children.count == 0
        # do nothing
      else
        @categories.append(cat)
      end
    end
    if @product.activated
      @product_activated = 1
    else
      @product_activated = 0
    end
    if @product.hold && @product.activated
      if @product.deals.count == 0
        redirect_to @product
      else
        redirect_to @product.deals.first
      end
    end
    if current_user.stores.length > 0
      @has = true
      stos = Array.new
      @product.user.stores.each do |s|
        stos.push([s.name, s.id])
      end
      stos.push(["None", nil])
      @stos = stos
      @default = @product.store
    else
      @has = false
    end
  end

  def pickup
    @product = Product.find(params[:id])
    has = false
    if @product.store_id.nil?
      for link in @product.exchange_method_links
        if link.exchange_method.method == "Pickup"
          has = true
        end
      end
    end
    if has
      exchange_method_link = ExchangeMethodLink.where("product_id=? AND exchange_method_id=?", @product.id, 3).first
      exchange_method_link.destroy
      flash[:warning] = "Can't have pick up without a store!"
    end      
  end

  def update
    @product = Product.find(params[:id])
    if !@product.sold
      if params[:store_id] && store = Store.find_by(id: params[:store_id]) and store.id != @product.store.id
        @product.store.id = store.id
      end
      
      toggle_options = params[:toggle_options]
      selling_methods = params[:selling_method_links]
      exchange_methods = params[:exchange_method_links]
      payment_methods = params[:payment_method_links]

      if !selling_methods.nil? && selling_methods.count != 0
        @product.selling_method_links.each do |l|
          l.destroy
        end
      end

      if !exchange_methods.nil? && exchange_methods.count != 0
        @product.exchange_method_links.each do |l|
          l.destroy
        end
      end

      if !payment_methods.nil? && payment_methods.count != 0
        @product.payment_method_links.each do |l|
          l.destroy
        end
      end

      if !toggle_options.nil? && toggle_options.count != 0
        @product.toggle_options.destroy_all
      end
      
      @product.update_attributes(product_params)
      if !toggle_options.nil?
        toggle_options.each do |attr|
          toggle_option = ToggleOption.joins('INNER JOIN `attribute_options` ON `attribute_options`.`id` = `toggle_options`.`attribute_option_id`').where("product_id = ? AND attribute_options.category_option_id = ?", @product.id, attr[0]).first_or_initialize
          toggle_option.update(attribute_option_id: attr[1]["name"], product_id: @product.id)
          toggle_option.save
          @product.save
        end
      end

      if !payment_methods.nil?
        payment_methods.each do |id, selected|
          @product.payment_method_links.build(payment_method_id: id).save if selected["id"].to_i == 1
        end
      end

      if !exchange_methods.nil?
        exchange_methods.each do |id, selected|
          @product.exchange_method_links.build(exchange_method_id: id).save if selected["id"].to_i == 1
        end
      end

      if !selling_methods.nil?
        selling_methods.each do |id, selected|
          @product.selling_method_links.build(selling_method_id: id).save if selected["id"].to_i == 1
        end
      end

      
      has_methods = @product.selling_method_links.count > 0 && @product.exchange_method_links.count > 0 && @product.payment_method_links.count > 0
      if !@product.store.nil?
        @product.full_street_address = @product.store.full_street_address
      elsif @product.full_street_address.nil?
        @product.full_street_address = @product.user.full_street_address
      end

      debugger
      if params[:product][:redirect_pictures].to_i == 1
        @product.save
        redirect_to add_pictures_product_path(@product.id)
        return
      end
      
      if @product.save
        if params[:product][:on_deals]
          deal = Deal.find(params[:product][:deal_id])
          if @product.changed?
            deal.exchange_agreement_seller = false
            deal.exchange_agreement_buyer = false
            deal.agreement_achieved = false
            deal.save
            redirect_to deal
            return
          end
        end
        flash[:success] = "You have successfully edited your product!"
        redirect_to @product
      else
        if current_user.stores.length > 0
          @has = true
          stos = Array.new
          @selling_methods = SellingMethod.all
          @payment_methods = PaymentMethod.all
          @edit = true
          @exchange_methods = ExchangeMethod.all
          @product = Product.find(params[:id])
          @product.user.stores.each do |s|
            stos.push([s.name, s.id])
          end
          stos.push(["None", nil])
          @stos = stos
          @default = @product.user.stores.first
        else
          @product = current_user.products.build
          @has = false
        end
        flash.now[:warning] = "Product edit failed."
        redirect_to edit_product_path(@product)
      end

    else
      @product.update_attributes(product_params) if !@product.agreement_achieved
      redirect_to @product
    end
  end

  def add_pictures
    @product = Product.find(params[:id])
    if params[:picture_id]
      @picture = Picture.find_by(id: params[:picture_id])
      if Rails.env.production?
        img = MiniMagick::Image.open(@picture.photo.url)
      else
        img = MiniMagick::Image.open(@picture.photo.path)
      end
      maxDim = img.height
      maxDim = img.width unless img.height > img.width
      @factor = 600.0 / maxDim
    else
      @picture = nil
    end
  end

  def add_cropped
    @product = Product.find(params[:id])
    @picture = Picture.find(params[:picture_id])
    if Rails.env.production?
      img = MiniMagick::Image.open(@picture.photo.url)
    else
      img = MiniMagick::Image.open(@picture.photo.path)
    end
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
    debugger
    @new_picture = @product.pictures.build
    @new_picture.photo = File.open(img.path)
    @new_picture.photo_cropped = @new_picture.photo

    @new_picture.save
    @product.save

    redirect_to @new_picture.post
  end

  private
  def product_params
    params.require(:product).permit(:price, :category_id, :full_street_address, :picture, :description, :store_id, :title, :min_accepted_price, :delivery_cost, :hold, :sold)
  end
  
  def correct_user
    @product  = Product.find_by(id: params[:id])
    if !current_user.products.include?(@product)
      redirect_to root_url
    end
  end
end
