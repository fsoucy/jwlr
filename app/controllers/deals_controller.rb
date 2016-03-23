class DealsController < ApplicationController
  def create
    @deal = current_user.buying_deals.build(deals_params)
    if !@deal.product.sold && !@deal.product.hold
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
      if @deal.product.selling_method_links.count == 1
        @deal.selling_method = @deal.product.selling_method_links.first.selling_method
      end
      @deal.exchange_method = @deal.product.exchange_method_links.first.exchange_method if @deal.product.exchange_method_links.count == 1
      @deal.payment_method = @deal.product.payment_method_links.first.payment_method if @deal.product.payment_method_links.count == 1
      @deal.save
      redirect_to @deal
    else
      flash[:warning] = "Deal could not be completed"
      redirect_to @deal.product
    end
    else
      redirect_to @deal.product
    end
  end

  def update
    @deal = Deal.find(params[:id])
    if !@deal.product.sold
    @deal.assign_attributes(deals_params)
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
        @deal.assign_attributes(buyer_params_unaccepted)
      end
    end
    if @deal.changed? && !@deal.exchange_agreement_buyer_changed? && !@deal.exchange_agreement_seller_changed? && !@deal.agreement_achieved
      @deal.exchange_agreement_buyer = false
      @deal.exchange_agreement_seller = false
    end 
    selling_agreement = false
    if (@deal.selling_method.id == 2 or ((@deal.selling_method.id == 3 or @deal.selling_method.id == 4) and @deal.proposed_price_accepted))
      selling_agreement = true
    end
    if @deal.selling_method.id == 2
      @deal.user_proposed_price = @deal.product.price
    end 
    exchange_agreement = false
    if (@deal.exchange_agreement_buyer and @deal.exchange_agreement_seller)
      exchange_agreement = true
    end
    @deal.product.hold = @deal.exchange_agreement_buyer
    exchange_agreement = ((@deal.exchange_agreement_buyer and @deal.exchange_agreement_seller) or (!@deal.product.store.nil? and pickup))
    @deal.agreement_achieved = (selling_agreement and exchange_agreement)
    @deal.deal_complete = (@deal.buyer_satisfied and @deal.seller_satisfied and @deal.payment_complete and @deal.product_received and @deal.agreement_achieved)
    if @deal.deal_complete
      @deal.product.sold = true
    end
    @deal.product.save
    if @deal.selling_method.id == 2
      @deal.proposed_price_accepted = true
    end
    if @deal.exchange_method.id != 1
      @deal.dropoff = nil
    end
    @deal.save
    end
    redirect_to @deal
  end
  
  def show
    @deal = Deal.find_by(id: params[:id])
  end

  private
  def deals_params
    params.require(:deal).permit(:seller_id, :buyer_id, :product_id) 
  end

  def seller_params_unaccepted
    params.require(:deal).permit(:exchange_agreement_seller, :delivery_cost, :proposed_price_accepted)
  end

  def buyer_params_unaccepted
    params.require(:deal).permit(:exchange_agreement_buyer, :user_proposed_price, :dropoff, :selling_method_id, :exchange_method_id, :payment_method_id)
  end

  def seller_params_accepted
    params.require(:deal).permit(:product_dispatched, :seller_satisfied, :payment_received)
  end

  def buyer_params_accepted
    params.require(:deal).permit(:product_received, :buyer_satisfied)
  end
end
