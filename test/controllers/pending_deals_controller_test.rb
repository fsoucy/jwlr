require 'test_helper'

class PendingDealsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @userTwo = users(:thing)
    @userFour = users(:archer)
    @userOther = users(:lana)
    @deal = pending_deals(:two)
  end

=begin
  test "must be logged in for deal" do
    get :show, id: @deal.id
    assert_redirected_to login_url
  end
=end

=begin
  test "must be logged in to change deal" do
    patch :update, id: @deal.id, pending_deal: { buyer_price: 300.0 }
    assert_redirected_to login_url
  end
=end

  test "can't get deal as wrong user" do
    log_in_as(@userOther)
    get :show, id: @deal.id
    assert_redirected_to root_url
  end

=begin
  test "can't update deal as wrong user" do
    log_in_as(@userOther)
    patch :update, id: @deal.id, pending_deal: { buyer_price: 300.0 }
    assert_redirected_to root_url
  end
=end

  test "can get deal as right user" do
    log_in_as(@userTwo)
    get :show, id: @deal.id
    assert_response :success    
  end

  test "can't update seller info as buyer" do
    log_in_as(@userTwo)
    get :show, id: @deal.id
    patch :update, id: @deal.id, pending_deal: { seller_price: 200.0 }
    assert_equal 100.0, @deal.reload.seller_price
  end

  test "can update buyer info as buyer" do
    log_in_as(@userTwo)
    get :show, id: @deal.id
    patch :update, id: @deal.id, pending_deal: { buyer_price: 200.0 }
    assert_equal 200.0, @deal.reload.buyer_price
  end
end
