require 'test_helper'

class SummarizedSubjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get summarized_subjects_show_url
    assert_response :success
  end

end
