class StoresController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @store = current_user.stores.build
  end

  def create
    @store = current_user.stores.build(store_params)
    if @store.save
      flash[:success] = "Store created!"
      redirect_to edit_times_store_path(@store.id)
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
      render 'stores/edit'
    end         
  end

    
  def show
    @store = Store.find_by(id: params[:id])
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
    if current_user == Store.find(params[:id]).user
      @store = Store.find(params[:id])
      @minutes = []
      @hours = []
      for i in 1..12
        @hours.push([i.to_s, i])
      end
      for i in 1..60
        @minutes.push([i.to_s, i])
      end
    else
      redirect_to root_url
    end
  end

  private
    def store_params
      params.require(:store).permit(:description, :picture, :full_street_address, :name, :business_days_pickup, :mondayopen, :mondaystarthour, :mondaystartminute, :mondaystartampm)
    end

    def logged_in_user
      redirect_to root_url if !logged_in?
    end

    def correct_user
      redirect_to root_url if Store.find_by(id: params[:id]).user !=
                                                 current_user
    end
end
