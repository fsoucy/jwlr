require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get get_status" do
    get :get_status
    assert_response :success
  end

end
