require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get events_path
    assert_response :success
  end

  test "should get show" do
    get event_path(events(:one))
    assert_response :success
  end

  test "should get new" do
    get new_event_path
    assert_response :success
  end

  test "should post create" do
    post events_path, params: { event: { name: "New Event", location: "Test Location" } }
    assert_response :redirect
  end

  test "should get edit" do
    get edit_event_path(events(:one))
    assert_response :success
  end

  test "should patch update" do
    patch event_path(events(:one)), params: { event: { name: "Updated Event" } }
    assert_response :redirect
  end
end
