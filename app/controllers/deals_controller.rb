class DealsController < ApplicationController
  def create
  end

  private
  def deals_params
    params.require(:deal).permit(:seller_id, :buyer_id, :product_id, :selling_method_id, 
  end
end
