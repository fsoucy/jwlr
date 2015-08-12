class CompletedDealsController < ApplicationController
  def create
    deal = PendingDeal.find(params[:pending_deal_id])
    product = Product.find(deal.product_id)
    completed = current_user.active_completed_deals.build
    completed.price = deal.seller_price
    completed.exchange = deal.seller_exchange
    completed.location = product.full_street_address
    completed.commodity = product.commodity
    completed.seller_id = deal.seller_id
    completed.buyer_id = deal.buyer_id
    completed.fulfilled = false
    completed.pending_deal_id = deal.id
    completed.fulfilled_buyer = false
    completed.fulfilled_seller = false
    completed.complaint_buyer = false
    completed.complaint_seller = false    
    if completed.save
      redirect_to completed
    else
      redirect_to completed.seller
    end
  end

  def update
    @completed_deal = CompletedDeal.find(params[:id])
    @completed_deal.update_attributes(update_params)
    if @completed_deal.fulfilled_buyer == true && @completed_deal.fulfilled_seller == true
      pending = PendingDeal.find(@completed_deal.pending_deal_id)
      pending.active = false
      pending.save
      @completed_deal.fulfilled = true
      @completed_deal.save
    end
    if @completed_deal.complaint_buyer
      CompletedDealMailer.complaint(User.find(@completed_deal.buyer_id)).deliver_now
    end
    if @completed_deal.complaint_seller
      CompletedDealMailer.complaint(User.find(@completed_deal.seller_id)).deliver_now
    end
    flash[:success] = "Updated successfully!"
    redirect_to @completed_deal
  end

  def show
    @completed_deal = CompletedDeal.find(params[:id])
  end

  private
  def update_params
    params.require(:completed_deal).permit(:fulfilled_buyer, :fulfilled_seller, :complaint_buyer, :complaint_seller)
  end

end
