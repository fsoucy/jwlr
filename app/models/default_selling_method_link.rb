class DefaultSellingMethodLink < ActiveRecord::Base
  belongs_to :selling_method
  belongs_to :user

end
