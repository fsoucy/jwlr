class Picture < ActiveRecord::Base
  belongs_to :product
  has_attached_file :photo #, :styles => { :medium => ["300x300>", :png], :thumb => ["200x200>", :png] }
  has_attached_file :photo_cropped, :styles => { :medium => ["200x200>", :png], :thumb => ["100x100>", :png] }
  validates_attachment :photo, :storage => :filesystem, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }, :size => { :less_than => 10.megabyte }


end
