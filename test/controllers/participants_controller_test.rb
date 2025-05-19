require "test_helper"

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "should post create" do
    post event_participants_path(events(:one)), params: { name: "Test Participant" }
    assert_response :redirect
  end
end
