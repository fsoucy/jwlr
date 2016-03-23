class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  before_action :correct_user_deal, only: [:new, :create]  

  def new
    deal = Deal.find(params[:id])
    @review = deal.reviews.build
    render 'new'   
  end

  def create
    deal = Deal.find(params[:id])
    review = deal.reviews.build(review_params)
    review.user = current_user
    if review.save
      redirect_to deal
    else
      render 'new'
    end
  end

  def index
    @selling_reviews = Review.joins("INNER JOIN deals ON deals.id = reviews.deal_id").where("deals.seller_id = ? and user_id != ?", params[:id], params[:id])
    @buying_reviews = Review.joins("INNER JOIN deals ON deals.id = reviews.deal_id").where("deals.buyer_id = ? and user_id != ?", params[:id], params[:id])
    @user = User.find(params[:id])
  end

  private

    def review_params
      params.require(:review).permit(:message, :verdict)
    end

    def correct_user_deal
      deal = Deal.find(params[:id])
      if !(deal.reviews.count > 1) && deal.deal_complete
        if deal.reviews.count == 0
          if !(deal.seller == current_user || deal.buyer == current_user)
            redirect_to deal.product
          end
        else
          if deal.reviews.first.user == current_user
            redirect_to deal
          end
        end
      else
        redirect_to deal
      end
    end
end
