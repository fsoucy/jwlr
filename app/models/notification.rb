class Notification < ActiveRecord::Base
  belongs_to :user

  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

  def send_notification_email
    NotificationMailer.send_notification(self).deliver_now
  end

end

