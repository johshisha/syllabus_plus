require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get usage" do
    get static_pages_usage_url
    assert_response :success
  end

end
