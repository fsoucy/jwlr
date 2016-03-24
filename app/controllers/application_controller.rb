class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include NotificationsHelper  

  before_filter :expire_hsts
 
  private
    def expire_hsts
      response.headers["Strict-Transport-Security"] = 'max-age=0'
    end

    def logged_in_user
      unless logged_in?
	      store_location
	      flash[:danger] = "You must be logged in to do that"
	      redirect_to login_url
      end
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end    
end
