require "test_helper"

class RacingCalendarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get racing_calendar_index_url
    assert_response :success
  end
end
