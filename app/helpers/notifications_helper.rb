module NotificationsHelper
  def new_notification(message, user, url)
    notification = user.notifications.build
    notification.message = message
    note.url = url
    notification.read = false
    notification.save
    NotificationMailer.send_notification(notification).deliver_now
  end
end
