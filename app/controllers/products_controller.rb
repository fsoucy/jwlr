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
    @picture = Picture.new

    if current_user.stores.length > 0
      @has = true
      stos = Array.new
      @product.user.stores.each do |s|
        stos.push([s.name, s.id])
      end
      @stos = stos
      @default = @product.user.stores.first
    else
      @has = false
    end
    @product.save(validate: false)
  end
  
  def create
    toggle_options = params[:toggle_options]
    selling_methods = params[:selling_method_links]
    exchange_methods = params[:exchange_method_links]
    payment_methods = params[:payment_method_links]
    if params[:store_id] != nil && store = Store.find_by(params[:store_id])
      @product = store.products.build(product_params)
      @product.full_street_address = store.full_street_address
      @product.save
      toggle_options.each do |attr|
        toggle_option = ToggleOption.joins('INNER JOIN `attribute_options` ON `attribute_options`.`id` = `toggle_options`.`attribute_option_id`').where("product_id = ? AND attribute_options.category_option_id = ?", @product.id, attr[0]).first_or_initialize
        toggle_option.update(attribute_option_id: attr[1]["name"], product_id: @product.id)
        toggle_option.save
      end
      payment_methods.each do |id, selected|
        @product.payment_method_links.build(payment_method_id: id).save if selected["id"].to_i == 1
      end
      exchange_methods.each do |id, selected|
        @product.exchange_method_links.build(exchange_method_id: id).save if selected["id"].to_i == 1
      end
      selling_methods.each do |id, selected|
        @product.selling_method_links.build(selling_method_id: id).save if selected["id"].to_i == 1
      end
    else
      @product = current_user.products.build(product_params)
      @product.full_street_address = current_user.full_street_address
      @product.save
      toggle_options.each do |attr|
        toggle_option = ToggleOption.joins('INNER JOIN `attribute_options` ON `attribute_options`.`id` = `toggle_options`.`attribute_option_id`').where("product_id = ? AND attribute_options.category_option_id = ?", @product.id, attr[0]).first_or_initialize
        toggle_option.update(attribute_option_id: attr[1]["name"], product_id: @product.id)
        toggle_option.save
        @product.save
      end
      payment_methods.each do |id, selected|
        @product.payment_method_links.build(payment_method_id: id).save if selected["id"].to_i == 1
      end
      exchange_methods.each do |id, selected|
        @product.exchange_method_links.build(exchange_method_id: id).save if selected["id"].to_i == 1
      end
      selling_methods.each do |id, selected|
        @product.selling_method_links.build(selling_method_id: id).save if selected["id"].to_i == 1
      end
    end
    @product.min_accepted_price = 0.0
    @product.min_accepted_price = @product.price * @product.user.acceptance_percentage unless @product.user.acceptance_percentage.nil?
    has_methods = @product.selling_method_links.count > 0 && @product.exchange_method_links.count > 0 && @product.payment_method_links.count > 0
    if @product.save and has_methods
      flash[:success] = "You have successfully uploaded a new product!"
      redirect_to @product
    else
      if current_user.stores.length > 0
        @has = true
        stos = Array.new
        @selling_methods = SellingMethod.all
        @payment_methods = PaymentMethod.all
        @exchange_methods = ExchangeMethod.all
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
      @edit = false
      flash.now[:warning] = "Product upload failed."
      render 'new'
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    if (!@product.activated and @product.user.id == current_user.id)
      redirect_to edit_product_path(@product)
      return
    end

    @buy_now = @product.buy_now
    @only_buy_now = @product.only_buy_now
    @delivery = false
    
    
    if logged_in?
      @deal = current_user.buying_deals.build(seller_id: @product.user.id, product_id: @product.id)
      @current_user = current_user
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
    if @product.hold && @product.activated
      if @product.deals.count == 0
        redirect_to @product
      else
        redirect_to @product.deal
      end
    end
    if current_user.stores.length > 0
      @has = true
      stos = Array.new
      @stos = stos
      @product.user.stores.each do |s|
        stos.push([s.name, s.id])
      end
      @default = @product.user.stores.first
    else
      @has = false
    end
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
        @product.save
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
      @product.save
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
      if @product.store_id != nil
        @product.full_street_address = @product.store.full_street_address
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
          @stos = stos
          @default = @product.user.stores.first
        else
          @product = current_user.products.build
          @has = false
        end
        flash.now[:warning] = "Product edit failed."
        redirect_to edit_product_path(@product)
      end

    end
      """
    if !pictewure.nil?
      if @product.pictures.count < 1
        flash[:warning] = your product must have bla
        redirect_to new_picture_url
        return
      end
      if @product.min_accepted_price.nil?
        @product.min_accepted_price = 0.0
      end
      @product.save
    end
    end
    unless product_params.nil?
      @product.assign_attributes(product_params)
      if params[:product][:on_deals]
        deal = Deal.find(params[:product][:deal_id])
        if @product.changed?
          deal.exchange_agreement_buyer = false
          deal.exchange_agreement_seller = false
          deal.agreement_achieved = false
          deal.save
        end
        @product.save
        redirect_to deal
        return
      end
      @product.save
      redirect_to edit_toggle_options_product_path(@product.id)
    end
    else
      redirect_to @product
    end
"""
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
