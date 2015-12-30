class Store < ActiveRecord::Base
  belongs_to :user
  mount_uploader :picture, PictureUploader    
  validate :selected_times

  def selected_times
    things = []
    things.push(mondaystarthour, tuesdaystarthour, wednesdaystarthour, thursdaystarthour, fridaystarthour, saturdaystarthour, sundaystarthour, mondaystartminute, tuesdaystartminute, wednesdaystartminute, thursdaystartminute, fridaystartminute, saturdaystartminute, sundaystartminute, mondayendhour, tuesdayendhour, wednesdayendhour, thursdayendhour, fridayendhour, saturdayendhour, sundayendhour, mondayendminute, tuesdayendminute, wednesdayendminute, thursdayendminute, fridayendminute, saturdayendminute, sundayendminute)
    for thing in things
      if thing == -1
        errors.add(:store, "You need times!")
      end
    end
  end 
      
end
