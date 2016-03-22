class DealsController < ApplicationController
  def create
    @deal = current_user.buying_deals.build(deals_params)
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
  end

  def update
    @deal = Deal.find(params[:id])
    @deal.update(deals_params)
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
    @deal.product.save
    exchange_agreement = ((@deal.exchange_agreement_buyer and @deal.exchange_agreement_seller) or (!@deal.product.store.nil? and pickup))
    @deal.agreement_achieved = (selling_agreement and exchange_agreement)
    @deal.deal_complete = (@deal.buyer_satisfied and @deal.seller_satisfied and @deal.payment_complete and @deal.product_received and @deal.agreement_achieved)
    if @deal.selling_method.id == 2
      @deal.user_proposed_price = nil
      @deal.proposed_price_accepted = false
    end
    if @deal.exchange_method.id != 1
      @deal.dropoff = nil
    end
    @deal.save
    redirect_to @deal
  end
  
  def show
    @deal = Deal.find_by(id: params[:id])
  end

  private
  def deals_params
    params.require(:deal).permit(:seller_id, :buyer_id, :product_id, :selling_method_id, :exchange_method_id, :payment_method_id, :user_proposed_price, :proposed_price_accepted, :dropoff, :exchange_agreement_seller, :exchange_agreement_buyer) 
  end
end
