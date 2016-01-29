class BlogpostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_store, only: [:new, :create]
  before_action :correct_user_blogpost, only: [:edit, :update, :destroy]  

  def new
    @blogpost = Blogpost.new
  end
  
  def create
    @blogpost = current_user.stores.find(params[:id]).blogposts.build(blogpost_params)
    if @blogpost.save
      flash[:success] = "Blogpost created!"
      redirect_to @blogpost.store
    else
      render 'new'
    end
  end
  
  def edit
    @blogpost = Blogpost.find(params[:id])
  end
  
  def update
    @blogpost = Blogpost.find(params[:id])
    if @blogpost.update_attributes(blogpost_params)
      flash[:success] = "Blogpost updated!"
      redirect_to @blogpost.store
    else
      render 'edit'
    end
  end
  
  def destroy
    @blogpost = Blogpost.find(params[:id])
    @blogpost.destroy
    flash[:success] = "Blogpost deleted"
    redirect_to @blogpost.store
  end

  private

    def blogpost_params
      params.require(:blogpost).permit(:title, :content)
    end
   
    def logged_in_user
      redirect_to root_url if !logged_in?
    end

    def correct_user_store
      @store = current_user.stores.find(params[:id])
      redirect_to root_url if @store.nil?
    end

    def correct_user_blogpost
      @blogpost = Blogpost.find(params[:id])
      redirect_to root_url if @blogpost.store.user != current_user
    end
  
end
