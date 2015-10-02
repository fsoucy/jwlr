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
    deal.exchange_public_buyer = User.find(params[:buyer_id]).public
    if deal.exchange_public_seller || deal.exchange_public_buyer
      datetime = 2.days.from_now
      date = datetime.to_date
      time = datetime.to_time
      deal.seller_location = product.full_street_address
      deal.buyer_location = product.full_street_address
      deal.buyer_hour = time.hour
      deal.seller_hour = time.hour
      if time.hour > 12
        buyer_hour = time.hour - 12
        seller_hour = time.hour - 12
      end
      deal.seller_month = date.month
      deal.buyer_month = date.month
      deal.buyer_day = date.day
      deal.seller_day = date.day
      deal.am = true if time.hour < 12
      buyer.am = true if time.hour < 12
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
  end

  private

  def update_params_buyer
    params.require(:pending_deal).permit(:buyer_location, :buyer_hour, :buyer_month, :buyer_day, buyer_price, buyer_am)
  end

  def update_params_seller
    params.require(:pending_deal).permit(:seller_location, :seller_hour, :seller_month, :seller_day, :seller_price, :seller_am)
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
