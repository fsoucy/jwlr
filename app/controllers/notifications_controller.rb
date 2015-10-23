class NotificationsController < ApplicationController
  def update
    notification = Notification.find(params[:id])
    notification.update_attributes(pars)
    redirect_to notification.user
  end

  private
  def pars
    params.require(:notification).permit(:read)
  end
end
