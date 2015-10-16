class NotificationsController < ApplicationController
  def update
    notification = Notification.find(params[:id])
    notification.update_attributes(pars)
    redirect_to User.find(1)
  end

  private
  def pars
    params.require(:notification).permit(:read)
  end
end
