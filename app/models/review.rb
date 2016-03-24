class Review < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user
  validates :verdict, presence: true
  validates_inclusion_of :verdict, :in => ["Positive", "Neutral", "Negative"]
  validates :message, presence: true
end
