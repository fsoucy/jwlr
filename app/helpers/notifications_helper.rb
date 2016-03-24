module NotificationsHelper
 def new_notification(message, user, url)
    notification = user.notifications.build
    notification.message = message + ' <a href="' + url + '">Click here</a>'
    notification.read = false
    notification.save
    NotificationMailer.send_notification(notification).deliver_now
  end
end
