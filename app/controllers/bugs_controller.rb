class BugsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  before_action :admin_user, only: [:update, :index]
  
  def new
    @bug = Bug.new
  end

  def index
    @bugs = Bug.all
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.save
    flash[:success] = "Bug report filed! Thanks for your help."
    redirect_to current_user
  end

  def update
    @bug = Bug.find(params[:id])
    @bug.update_attributes(bug_params)
    @bug.save
    redirect_to "/bugs"
  end

  private
  def bug_params
    params.require(:bug).permit(:content, :url, :title, :fixed)
  end

  
end
