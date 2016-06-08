class Group < ActiveRecord::Base
  belongs_to :user
  has_many :members, foreign_key: "group_id", class_name: "Groupmember", dependent: :destroy

  def add_user(user)
    member = self.members.build(user_id: user.id)
    member.save
  end
end
