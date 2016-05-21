class MicropostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy, :update]

  def create
    micropost = current_user.microposts.build(micropost_params)
    micropost.save
    redirect_to root_url
  end

  def destroy

  end

  def update

  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      micropost = Micropost.find_by(id: params[:id])
      if !current_user.microposts.include?(micropost)
        redirect_to root_url
      end
    end
end
