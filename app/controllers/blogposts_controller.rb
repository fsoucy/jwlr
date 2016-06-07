class BlogpostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_blogpost, only: [:edit, :update, :destroy]  

  def new
    @blogpost = Blogpost.new
    @has = false
    if current_user.stores.length > 0
      @has = true
      @stos = Array.new
      current_user.stores.each do |store|
        @stos.push([store.name, store.id])
      end
      @stos.push(["Post as a user", -1])
      @default = -1
    end
  end
  
  def create
    if params[:store_id].to_i == -1 or params[:store_id].nil?
      @blogpost = current_user.blogposts.build(blogpost_params)
    else
      store = current_user.stores.find_by(id: params[:store_id])
      if !store.nil?
        @blogpost = store.blogposts.build(blogpost_params)
        @blogpost.user_id = current_user.id
      else
        redirect_to root_url
      end
    end
    if @blogpost.save
      flash[:success] = "Blogpost created!"
      redirect_to @blogpost.store if !@blogpost.store.nil?
      redirect_to @blogpost.user unless !@blogpost.store.nil?
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
      redirect_to @blogpost.store if !@blogpost.store.nil?
      redirect_to @blogpost.user
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

    def correct_user_blogpost
      @blogpost = Blogpost.find(params[:id])
      if @blogpost.store.nil?
        redirect_to root_url if @blogpost.user != current_user
      else
        redirect_to root_url if @blogpost.store.user != current_user
      end
    end
  
end
