require "test_helper"

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  test "should post create" do
    post attendances_path, params: { attendance: { date_option_id: date_options(:one).id, participant_id: participants(:one).id, status: 'attending' } }
    assert_response :redirect
  end

  test "should patch update" do
    patch attendance_path(attendances(:one)), params: { attendance: { status: 'not_attending' } }
    assert_response :redirect
  end
end
