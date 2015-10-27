class PendingDealsController < ApplicationController
  before_action :logged_in_user, only: [:create, :update, :destroy, :show]
  before_action :correct_user, only: [:show]
  
  def create
    deal = current_user.active_deals.build(seller_id: params[:seller_id], product_id: params[:product_id])
    product = Product.find_by(id: deal.product_id)
    deal.seller_price = product.price
    deal.buyer_price = product.price
    deal.active = true
    deal.exchange_public_seller = User.find(params[:seller_id]).public
    deal.exchange_public_buyer = User.find(deal.buyer_id).public
    if deal.product.store_id == nil
      datetime = 2.days.from_now
      deal.seller_datetime = datetime
      deal.buyer_datetime = datetime
      deal.buyer_exchange = "Pickup"
      deal.seller_exchange = "Dropoff"
    else
      deal.seller_datetime = nil
      deal.buyer_datetime = nil
      deal.buyer_exchange = nil
      deal.seller_exchange = nil
    end      
    deal.save
    redirect_to product
  end

  def update
    @deal = PendingDeal.find(params[:id])
    if current_user.id == @deal.buyer_id
      if @deal.update_attributes(update_params_buyer)
        flash[:success] = "Pending Deal Updated."
        redirect_to @deal
      else
        flash[:warning] = "Unsucessful Update."
        redirect_to @deal
      end
    elsif current_user.id == @deal.seller_id
      if @deal.update_attributes(update_params_seller)
        flash[:success] = "Pending Deal Updated."
        redirect_to @deal
      else
        flash[:warning] = "Unsucessful Update."
        redirect_to @deal
      end
    end
  end

  def destroy
    deal = PendingDeal.find(params[:id])
    product = Product.find(deal.product_id)
    CompletedDeal.find(deal.completed_deal_id).destroy if deal.completed
    deal.destroy
    flash[:success] = "Successfully deleted pending deal."
    redirect_to product
  end

  def show
    @deal = PendingDeal.find(params[:id])
    @public = @deal.product.store_id != nil
  end

  private

  def update_params_buyer
    params.require(:pending_deal).permit(:buyer_exchange, :buyer_datetime, :buyer_price)
  end

  def update_params_seller
    params.require(:pending_deal).permit(:seller_datetime, :seller_price, :seller_exchange)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    deal = PendingDeal.find(params[:id])
    unless current_user.id == deal.buyer_id || current_user.id == deal.seller_id
      flash[:danger] = "You can't go there."
      redirect_to root_url
    end
  end
  
end
