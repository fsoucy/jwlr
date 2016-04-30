module NotificationsHelper
  def new_notification(message, user, url)
    notification = user.notifications.build
    notification.message = '<a href="' + url + '">' + message + '</a>'
    notification.read = false
    notification.save
    NotificationMailer.send_notification(notification).deliver_now
  end
end
