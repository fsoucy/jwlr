class Picture < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  
  has_attached_file :photo, default_url: "/assets/missing_large.jpg", :styles => { :large => ["100%", :jpg]}, :convert_options => { :all => '-strip -quality 100 -alpha remove -background white'}, :default_style => :large
  has_attached_file :photo_cropped, :convert_options => { :big => '-gravity center -crop 600x600+0+0', :medium => '-gravity center -crop 300x300+0+0', :thumb => '-gravity center -crop 200x200+0+0', :thumbnail => '-gravity center -crop 50x50+0+0', :all => '-strip -quality 100 -alpha remove -background white' }, :styles => { :large => ["100%", :jpg], :big => ["600x600^", :jpg], :medium => ["300x300^", :jpg], :thumb => ["200x200^", :jpg], :thumbnail => ["50x50^", :jpg] }, default_url: "/assets/missing_:style.jpg"
  validates_attachment :photo, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }, :size => { :less_than => 10.megabyte }
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
