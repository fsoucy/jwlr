class StatusesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy, :show]

  def new
    @status = current_user.statuses.build
  end

  def create
    @status = current_user.statuses.build(status_params)
    if @status.save
      flash[:success] = "Status updated!"
      redirect_to root_url
    else
      render 'statuses/new'
    end
  end

  def destroy
    @status = Status.find_by(id: params[:id])
    @status.destroy
    flash[:success] = "Successfully deleted status!"
    redirect_to root_url
  end
  
  def show
    @status = Status.find_by(id: params[:id])
  end

  def matches
    @status = Status.find_by(id: params[:id])
  end

  private
    def status_params
      params.require(:status).permit(:minPrice, :maxPrice, :toTravel, :full_street_address, :buying, :commodity)
    end
  
    def logged_in_user
      redirect_to root_url if !logged_in?
    end

    def correct_user
      redirect_to root_url if Status.find_by(id: params[:id]).user !=
      		  	      			 current_user
    end
end
