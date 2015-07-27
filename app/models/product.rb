class Product < ActiveRecord::Base
  geocoded_by :full_street_address
  after_validation :geocode
  belongs_to :user
  mount_uploader :picture, PictureUploader
end
