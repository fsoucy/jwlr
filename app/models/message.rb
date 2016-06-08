class Message < ActiveRecord::Base
  belongs_to :conversation, dependent: :destroy
  belongs_to :sender, class_name: "User"
  belongs_to :product
end
