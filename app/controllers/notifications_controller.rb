class NotificationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:index]
  before_action :correct_user_notification, only: [:update]

  def update
    notification = Notification.find(params[:id])
    notification.update_attributes(notification_params)
    redirect_to notifications_path(notification.user)
  end

  def index
    @notifications = Notification.where("user_id = ?", params[:id]).paginate(:page => params[:page], per_page: 15).order(created_at: :desc)
  end

  private
    def notification_params
      params.require(:notification).permit(:read)
    end

    def correct_user
      if current_user != User.find(params[:id])
        redirect_to root_url
      end
    end

    def correct_user_notification
      notification = Notification.find(params[:id])
      if notification.user_id != current_user.id
        redirect_to root_url
      end
    end
end
