class MicropostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy, :update]

  def create
    micropost = current_user.microposts.build(micropost_params)
    micropost.save
    result = {id: micropost.id}
    render json: result.to_json, status: 200
  end

  def destroy
    micropost = Micropost.find_by(id: params[:id])
    micropost.destroy
    render json: nil, status: 200 
  end

  def update
    micropost = Micropost.find_by(id: params[:id])
    micropost.update_attributes(micropost_params)
    if micropost.save
      render json: nil, status: 200
    else
      render json: nil, status: 400
    end
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
