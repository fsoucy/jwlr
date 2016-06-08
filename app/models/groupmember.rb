class Groupmember < ActiveRecord::Base
  has_one :user, foreign_key: "id"
  belongs_to :group
end
