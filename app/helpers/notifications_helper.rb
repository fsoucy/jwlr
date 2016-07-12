module NotificationsHelper
  def new_notification(message, user, url)
    notification = user.notifications.build
    notification.message = message
    notification.url = url
    notification.read = false
    notification.save
    notification.send_notification_email
  end
end
