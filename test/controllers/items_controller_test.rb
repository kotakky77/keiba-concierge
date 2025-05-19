require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should post create" do
    post event_items_path(events(:one)), params: { item: { name: "Test Item", participant_id: participants(:one).id } }
    assert_response :redirect
  end

  test "should patch update" do
    patch event_item_path(events(:one), items(:one)), params: { item: { name: "Updated Item" } }
    assert_response :redirect
  end

  test "should delete destroy" do
    delete event_item_path(events(:one), items(:one))
    assert_response :redirect
  end
end
