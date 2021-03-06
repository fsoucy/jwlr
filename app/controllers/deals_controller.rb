class DealsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:update, :show, :destroy, :updated_at]
  
  def create
    @deal = current_user.buying_deals.build(deals_params)
    active_deal = Deal.where("product_id = ? and buyer_id = ?", @deal.product.id, current_user.id).first
    if active_deal.nil?
    if !@deal.product.sold && !@deal.product.hold && @deal.product.activated
    if @deal.save
      @deal.deal_complete = false
      @deal.dropoff = @deal.buyer.full_street_address
      @deal.product_received = false
      @deal.payment_complete = false
      @deal.proposed_price_accepted = false
      @deal.exchange_agreement_seller = false
      @deal.exchange_agreement_buyer = false
      @deal.agreement_achieved = false
      @deal.seller_satisfied = false
      @deal.buyer_satisfied = false
      @deal.complaint_buyer = false
      @deal.complaint_seller = false
      if @deal.product.selling_method_links.count == 1
        @deal.selling_method = @deal.product.selling_method_links.first.selling_method
      end
      @deal.exchange_method = @deal.product.exchange_method_links.first.exchange_method if @deal.product.exchange_method_links.count == 1
      @deal.payment_method = @deal.product.payment_method_links.first.payment_method if @deal.product.payment_method_links.count == 1
      if @deal.selling_method.method == "Static Price"
        @deal.user_proposed_price = @deal.product.price
        @deal.proposed_price_accepted = true
      end
      if @deal.selling_method.method == "Negotiation"
        @deal.proposed_price_accepted = false
      end
      @deal.save
      new_notification("A user has initiated a deal on your product " + @deal.product.title, @deal.product.user, deal_url(@deal))
      redirect_to @deal
    else
      flash[:warning] = "Deal could not be completed"
      redirect_to @deal.product
    end
    else
      redirect_to @deal.product
    end
    else
      redirect_to active_deal
    end
  end

  def update
    @deal = Deal.find(params[:id])
    old_selling_method = @deal.selling_method.method
    old_exchange_method = @deal.exchange_method.method
    if current_user == @deal.seller
      @deal.assign_attributes(seller_params_always)
      @deal.save
    elsif current_user == @deal.buyer
      @deal.assign_attributes(buyer_params_always)
      @deal.save
    end
    if !@deal.product.sold
      @deal.assign_attributes(deals_params)
      if @deal.changed?
        if current_user == @deal.seller
          new_notification("Your deal on " + @deal.product.title + " has been updated by the seller.", @deal.buyer, deal_url(@deal))
        else
          new_notification("Your deal on " + @deal.product.title + " has been updated by the buyer.", @deal.seller, deal_url(@deal))
        end
      end
      if @deal.agreement_achieved && !@deal.deal_complete
        if current_user == @deal.seller
          @deal.assign_attributes(seller_params_accepted)
        else
          @deal.assign_attributes(buyer_params_accepted)
        end
      end
      if !@deal.agreement_achieved && !@deal.deal_complete
        if current_user == @deal.seller
          @deal.assign_attributes(seller_params_unaccepted)
        else
          params[:deal][:user_proposed_price] = params[:deal][:user_proposed_price].to_i unless params[:deal][:user_proposed_price].nil?
          @deal.assign_attributes(buyer_params_unaccepted)
        end
      end
      if @deal.changed? && !@deal.exchange_agreement_buyer_changed? && !@deal.exchange_agreement_seller_changed? && !@deal.agreement_achieved
        @deal.exchange_agreement_buyer = false
        @deal.exchange_agreement_seller = false
      end
      if @deal.user_proposed_price_changed?
        @deal.exchange_agreement_buyer = false
        @deal.exchange_agreement_seller = false
        @deal.proposed_price_accepted = false
      end
      selling_agreement = false
      if (@deal.selling_method.id == 2 or ((@deal.selling_method.id == 3 or @deal.selling_method.id == 4) and @deal.proposed_price_accepted))
        selling_agreement = true
      end
      if @deal.selling_method.id == 2
        @deal.user_proposed_price = @deal.product.price
      end
      if @deal.exchange_method.method == "Pickup" || @deal.exchange_method.method == "Delivery"
        @deal.exchange_agreement_seller = true
      end
      exchange_agreement = false
      if (@deal.exchange_agreement_buyer and @deal.exchange_agreement_seller)
        exchange_agreement = true
      end
      
      @deal.product.hold = @deal.exchange_agreement_buyer
      exchange_agreement = ((@deal.exchange_agreement_buyer and @deal.exchange_agreement_seller) or (!@deal.product.store.nil? and @deal.exchange_method == 3))
      @deal.agreement_achieved = (selling_agreement and exchange_agreement)
      @deal.deal_complete = (@deal.buyer_satisfied and @deal.seller_satisfied and @deal.payment_complete and @deal.product_received and @deal.agreement_achieved)
      if @deal.deal_complete
        @deal.product.sold = true
      end
      @deal.product.save
      if @deal.selling_method.method == "Static Price"
        @deal.proposed_price_accepted = true
        @deal.user_proposed_price = @deal.product.price
      end
      if @deal.selling_method.method == "Negotiation" and old_selling_method == "Static Price"
        @deal.proposed_price_accepted = false
        @deal.user_proposed_price = 0.0
      end
      @deal.reason_complaint_seller = nil if @deal.complaint_seller == false
      @deal.reason_complaint_buyer = nil if @deal.complaint_buyer == false
      if @deal.dropoff_changed?
        location = Geocoder.search @deal.dropoff
        if location[0].street_address.nil? || location[0].street_address == ""
          @deal.dropoff = nil
          flash[:error] = "You need to use a full street address"
        end
      end
      if @deal.exchange_method.id != 1
        @deal.dropoff = nil
      end
      @deal.save
    end
    render json: nil, status: 200
  end
  
  def show
    @deal = Deal.find_by(id: params[:id])
    @conversation = Conversation.where("(first_user_id=? or first_user_id=?) AND (second_user_id=? or second_user_id=?)", @deal.seller.id, @deal.buyer.id, @deal.seller.id, @deal.buyer.id).first
    if @conversation.nil?
      @conversation = Conversation.new(first_user_id: @deal.seller.id, second_user_id: @deal.buyer.id)
      @conversation.save
    end
    @need_exchange = 0
    if !@deal.exchange_method_id.nil? && @deal.exchange_method.method == "Delivery" && !@deal.payment_method_id.nil? && @deal.payment_method.method != "Paypal"
      @deal.payment_method_id = 1
      @deal.save
      flash[:warning] = "You can't get a product delivered and pay upon transaction. You must use Paypal for delivery."
      @need_exchange = 1
    end
      
    last = @conversation.messages.count
    start = last - 50
    start = 0 if start < 0
    @messages = @conversation.messages[(start)..last]
    @msg = @conversation.messages.build
    pertinent_notifications = Notification.where("url=? AND user_id=?", request.original_url, current_user.id)
    pertinent_notifications.each do |n|
      n.read = true
      n.viewed = true
      n.save
    end
  end

  def destroy
    deal = Deal.find(params[:id])
    deal.product.hold = false
    deal.product.sold = false
    deal.product.save
    deal.destroy
    if deal.seller == current_user
      new_notification("Your deal on " + deal.product.title + " has been cancelled by the seller.", deal.buyer, product_url(deal.product))
    else
      new_notification("Your deal on " + deal.product.title + " has been cancelled by the buyer.", deal.seller, product_url(deal.product))
    end
    redirect_to deal.product
  end

  def updated_at
    deal = Deal.find(params[:id])
    render json: deal.updated_at.to_i, status: 200
  end

  private
  def deals_params
    params.require(:deal).permit(:seller_id, :buyer_id, :product_id, :selling_method_id, :exchange_method_id, :payment_method_id, :user_proposed_price) 
  end

  def seller_params_unaccepted
    params.require(:deal).permit(:exchange_agreement_seller, :delivery_cost, :proposed_price_accepted, :complaint_seller, :reason_complaint_seller)
  end

  def buyer_params_unaccepted
    params.require(:deal).permit(:exchange_agreement_buyer, :user_proposed_price, :dropoff, :selling_method_id, :exchange_method_id, :payment_method_id, :complaint_buyer, :reason_complaint_buyer)
  end

  def seller_params_accepted
    params.require(:deal).permit(:product_dispatched, :seller_satisfied, :payment_complete, :complaint_seller, :reason_complaint_seller)
  end

  def buyer_params_accepted
    params.require(:deal).permit(:product_received, :buyer_satisfied, :complaint_buyer, :reason_complaint_buyer, :exchange_agreement_buyer)
  end

  def seller_params_always
    params.require(:deal).permit(:complaint_seller, :reason_complaint_seller)
  end

  def buyer_params_always
    params.require(:deal).permit(:complaint_buyer, :reason_complaint_buyer)
  end

  def correct_user
    deal = Deal.find(params[:id])
    redirect_to root_url unless (deal.seller == current_user || deal.buyer == current_user)    
  end

end
