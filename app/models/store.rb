class Store < ActiveRecord::Base
  belongs_to :user
  validate :selected_times
  has_many :products, dependent: :destroy
  has_many :faqs, dependent: :destroy
  has_many :blogposts, dependent: :destroy
  has_attached_file :profile_picture, :styles => { :medium => ["300x300>", :png], :thumb => ["200x200>", :png], :thumbnail => ["50x50>", :png] }, default_url: "/images/:style/missing.png"
  validates_attachment :profile_picture, :storage => :filesystem, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }, :size => { :less_than => 10.megabyte }

  def selected_times
    things = []
    things.push(mondaystarthour, tuesdaystarthour, wednesdaystarthour, thursdaystarthour, fridaystarthour, saturdaystarthour, sundaystarthour, mondaystartminute, tuesdaystartminute, wednesdaystartminute, thursdaystartminute, fridaystartminute, saturdaystartminute, sundaystartminute, mondayendhour, tuesdayendhour, wednesdayendhour, thursdayendhour, fridayendhour, saturdayendhour, sundayendhour, mondayendminute, tuesdayendminute, wednesdayendminute, thursdayendminute, fridayendminute, saturdayendminute, sundayendminute)
    for thing in things
      if thing == -1
        errors.add(:store, "You need times!")
      end
    end
  end

  def valid_times
    if mondayopen
      if (mondaystarthour.nil? or mondayendhour.nil? or mondaystartminute.nil? or mondayendminute.nil?)
        return false
      end
    end
    if tuesdayopen
      if (tuesdaystarthour.nil? or tuesdayendhour.nil? or tuesdaystartminute.nil? or tuesdayendminute.nil?)
        return false
      end
    end
    if wednesdayopen
      if (wednesdaystarthour.nil? or wednesdayendhour.nil? or wednesdaystartminute.nil? or wednesdayendminute.nil?)
        return false
      end
    end
    if thursdayopen
      if (thursdaystarthour.nil? or thursdayendhour.nil? or thursdaystartminute.nil? or thursdayendminute.nil?)
        return false
      end
    end
    if fridayopen
      if (fridaystarthour.nil? or fridayendhour.nil? or fridaystartminute.nil? or fridayendminute.nil?)
        return false
      end
    end
    if saturdayopen
      if (saturdaystarthour.nil? or saturdayendhour.nil? or saturdaystartminute.nil? or saturdayendminute.nil?)
        return false
      end
    end
    if sundayopen
      if (sundaystarthour.nil? or sundayendhour.nil? or sundaystartminute.nil? or sundayendminute.nil?)
        return false
      end
    end
    return true
  end
      
  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end
end
