class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy, :add_user]

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def index
    @groups = current_user.groups.all
  end
    
  def show
    @group = Group.find(params[:id])
  end

  def create
    @group = current_user.groups.build(user_id: current_user.id, name: params[:group][:name])
    if @group.save
      @group.add_user(current_user)
      redirect_to groups_path
    else
     render 'new'
    end
  end

  def destroy 
    group = Group.find(params[:id])
    group.destroy
    flash[:success] = "Group deleted"
    redirect_to groups_path
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  def add_user
    group = Group.find(params[:id])
    member = group.members.find_or_initialize_by(user_id: params[:user_id])
    if member.persisted?
      member.destroy
      render json: nil, status: 200
    elsif member.save
      render json: nil, status: 200
    else
      render json: nil, status: 400
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def correct_user
    @group = Group.find(params[:id])
    if !current_user?(@group.user)
      redirect_to root_url
    end  
  end

end
