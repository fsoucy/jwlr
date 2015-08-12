class CompletedDeal < ActiveRecord::Base
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  belongs_to :pending_deal, class_name: "PendingDeal"
  after_create :completed_pending  
  validates :price, presence: true
  validates :exchange, presence: true
  validates :location, presence: true
  validates :commodity, presence: true
  validates :seller_id, presence: true
  validates :buyer_id, presence: true
  validates :pending_deal_id, presence: true

  def completed_pending
    deal = PendingDeal.find(self.pending_deal_id)
    deal.completed = true
    deal.completed_deal_id = self.id
    deal.save
  end
end
