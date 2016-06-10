class Group < ActiveRecord::Base
  belongs_to :user
  has_many :members, foreign_key: "group_id", class_name: "Groupmember", dependent: :destroy
  has_many :conversations, dependent: :destroy

  def add_user(user)
    member = self.members.build(user_id: user.id)
    member.save
  end

  def member?(member)
    self.members.include?(member)
  end

  def user_member?(user)
    self.members.each do |member|
      if member.user_id = user.id
        return true
      end
    end
    return false
  end
end
