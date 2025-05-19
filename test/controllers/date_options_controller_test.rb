require "test_helper"

class DateOptionsControllerTest < ActionDispatch::IntegrationTest
  test "should post create" do
    post event_date_options_path(events(:one)), params: { date_option: { date: "2025-06-01" } }
    assert_response :redirect
  end

  test "should delete destroy" do
    delete event_date_option_path(events(:one), date_options(:one))
    assert_response :redirect
  end
end
