class Picture < ActiveRecord::Base
  belongs_to :product
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "200x200>" }
  validates_attachment :photo, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }, :size => { :less_than => 10.megabyte }


end
