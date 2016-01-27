class StoresController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy, :edit_times]

  def new
    @store = current_user.stores.build
  end
  
  def create
    @store = current_user.stores.build(store_params)
    if @store.save
      flash[:success] = "Store created!"
	    redirect_edit_times(@store)
    else
      render 'stores/new'
    end
  end

  def edit
    @store = Store.find_by(id: params[:id])    
  end

  def update
    @store = Store.find_by(id: params[:id])
    if @store.update_attributes(store_params)
      flash[:success] = "Successfully updated your store!"
      redirect_to @store
	  else
      flash[:danger] = "You need a time for all your stuff!"
      redirect_to edit_times_store_path(@store.id)
    end         
  end
    
  def show
    @store = Store.find_by(id: params[:id])
    if @store.nil?
	   	redirect_to root_url
	  else
		  @products = @store.products
	  end
  end

  def destroy
    @store = Store.find_by(id: params[:id])
    @store.destroy
    flash[:success] = "You deleted your store. Sad to see it go!"
    redirect_to root_url    
  end

  def index
  end

  def edit_times
    @store = Store.find(params[:id])
    @minutes = []
    @hours = []
    @minutes.push(["Minute", -1])
    @hours.push(["Hour", -1])
    @minutes.push(["00", 0])
    for i in 1..12
      @hours.push([(sprintf("%0.2d", i)).to_s, i])
    end
    for i in 1..50
      @minutes.push([(sprintf("%0.2d", i)).to_s, i])
    end
  end

  private
    def store_params
      params.require(:store).permit(:description, :profile_photo, :full_street_address, :name, :phone, :business_days_pickup, :mondayopen, :mondaystarthour, :mondaystartminute, :mondaystartampm, :mondayendhour, :mondayendminute, :mondayendampm, :tuesdayopen, :tuesdaystarthour, :tuesdaystartminute, :tuesdaystartampm, :tuesdayendhour, :tuesdayendminute, :tuesdayendampm, :wednesdayopen, :wednesdaystarthour, :wednesdaystartminute, :wednesdaystartampm, :wednesdayendhour, :wednesdayendminute, :wednesdayendampm, :thursdayopen, :thursdaystarthour, :thursdaystartminute, :thursdaystartampm, :thursdayendhour, :thursdayendminute, :thursdayendampm, :fridayopen, :fridaystarthour, :fridaystartminute, :fridaystartampm, :fridayendhour, :fridayendminute, :fridayendampm, :saturdayopen, :saturdaystarthour, :saturdaystartminute, :saturdaystartampm, :saturdayendhour, :saturdayendminute, :saturdayendampm, :sundayopen, :sundaystarthour, :sundaystartminute, :sundaystartampm, :sundayendhour, :sundayendminute, :sundayendampm)
    end

    def logged_in_user
      redirect_to root_url if !logged_in?
    end

    def correct_user
      redirect_to root_url if Store.find_by(id: params[:id]).user != current_user
    end
	
    def redirect_edit_times(store)
      if !store.mondayopen? && !store.tuesdayopen? && !store.wednesdayopen? && !store.thursdayopen? && !store.fridayopen? && !store.saturdayopen? && !store.sundayopen?
        redirect_to store
      else
        redirect_to edit_times_store_path(store.id)
      end
    end
end
