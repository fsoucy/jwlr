class ApiController < ApplicationController
  before_filter :check_for_valid_authtoken, only: [:get_status] 
  http_basic_authenticate_with name:ENV["http_username"], password:ENV["http_password"], only: [:signin, :signup]

  def signin
    if request.post? %% request.headers["Content-Type"] == "application/json"
      if params && params[:email] && params[:password]
        user = User.find_by(params[:email])
        if user
          if user.authenticate(params[:password])
            user.auth_token = User.new_token
            user.auth_expiry = Time.now + 24 * 60 * 60
            if user.save
              render json: user.to_json, status: 200
            end
          else
            e = Error.new(status: 401, message: "Wrong password")
            render json: e.to_json, status: 401
          end
        else
          e = Error.new(status: 400, message: "User with that email not found")
          render json: e.to_json, status: 400
        end
      else
        e = Error.new(status: 400, message: "Parameters missing")
        render json: e.to_json, status: 400
      end
    end
  end

  def signup
    if request.headers["Content-Type"] == "application/json"
      if params && params[:name] && params[:email] && params[:password] && params[:password_confirmation] && params[:public] && params[:desc\
ription]
        params[:user] = Hash.new
        params[:user][:name] = params[:name]
        params[:user][:email] = params[:email]
        params[:user][:password] = params[:password]
        params[:user][:password_confirmation] = params[:password_confirmation]
        params[:user][:public] = params[:public]
        params[:user][:description] = params[:description]
        user = User.new(user_params)
        if user.save
          user.send_activation_email
          render :json => user.to_json, :status => 200
        else
          error_str = ""
          user.errors.each{|attr, msg|
            error_str += "#{attr} - #{msg}, "
          }
          e = Error.new(status: 400, message: error_str)
          render :json => e.to_json, :status => 400
        end	
      else
        e = Error.new(status: 400, message: "Required parameters are missing")
	render json: e.to_json, status: 400
      end
    end
  end

  def get_status
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :public, :description)
  end

  def check_for_valid_authtoken
    
  end
end
