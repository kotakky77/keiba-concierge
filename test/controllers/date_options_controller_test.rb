require "test_helper"

class DateOptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get date_options_create_url
    assert_response :success
  end

  test "should get destroy" do
    get date_options_destroy_url
    assert_response :success
  end
end
