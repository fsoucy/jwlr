require 'test_helper'

class PendingDealTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @deal = PendingDeal.new(buyer_id: 2, seller_id: 4, product_id: 30)
  end

  test "deal should be valid" do
    assert @deal.valid?
  end

  test "buyer needs to exist" do
    @deal.buyer_id = 10000
    assert_not @deal.valid?
  end

  test "product needs to exist" do
    @deal.product_id = 10000
    assert_not @deal.valid?
  end

  test "buyer and seller must be different" do
    @deal.seller_id = 1
    assert_not @deal.valid?
  end

  test "product needs to not be nil" do
    @deal.product_id = nil
    assert_not @deal.valid?
  end
end
