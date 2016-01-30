class Faq < ActiveRecord::Base
  belongs_to :store
  validates :store_id, presence: true
  validates :question, presence: true
  validates :answer, presence: true
end
