class DealsController < ApplicationController
  def create
    @deal = current_user.buying_deals.build(deals_params)
    if @deal.save
      @deal.deal_complete = false
      @deal.product_received = false
      @deal.payment_complete = false
      @deal.proposed_price_accepted = false
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
    redirect_to @deal
  end
  
  def show
    @deal = Deal.find_by(id: params[:id])
  end

  private
  def deals_params
    params.require(:deal).permit(:seller_id, :buyer_id, :product_id, :selling_method_id, :exchange_method_id, :payment_method_id, :user_proposed_price, :proposed_price_accepted) 
  end
end
