require 'test_helper'

class StockSubjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stock_subjects_index_url
    assert_response :success
  end

  test "should get new" do
    get stock_subjects_new_url
    assert_response :success
  end

  test "should get create" do
    get stock_subjects_create_url
    assert_response :success
  end

  test "should get destroy" do
    get stock_subjects_destroy_url
    assert_response :success
  end

end
