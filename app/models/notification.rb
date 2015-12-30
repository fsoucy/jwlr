class Notification < ActiveRecord::Base
  belongs_to :user

  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

end

