class NotificationMailer < ApplicationMailer

  def send_notification(notification)
    @notification = notification
    mail(to: notification.user.email, subject: 'New notification on iGold')
  end

end
