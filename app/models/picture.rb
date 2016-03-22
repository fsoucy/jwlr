class Picture < ActiveRecord::Base
  belongs_to :product
  has_attached_file :photo #, :styles => { :medium => ["300x300>", :png], :thumb => ["200x200>", :png] }
  has_attached_file :photo_cropped, :styles => { :medium => ["300x300>", :png], :thumb => ["200x200>", :png] }
  validates_attachment :photo, :storage => :filesystem, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }, :size => { :less_than => 10.megabyte }
  validate :check_dimensions  

  private
    def check_dimensions
      temp_file = photo.queued_for_write[:original]
      unless temp_file.nil?
        dimensions = Paperclip::Geometry.from_file(temp_file)
        width = dimensions.width
        height = dimensions.height
    
        if width < 300 && height < 300
          errors.add :photo, "Dimensions are too small. For a good quality image please upload a larger image. Minimum 300x300px"
        end
      end
    end 

end
