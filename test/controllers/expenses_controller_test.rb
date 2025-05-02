require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get expenses_create_url
    assert_response :success
  end

  test "should get update" do
    get expenses_update_url
    assert_response :success
  end

  test "should get destroy" do
    get expenses_destroy_url
    assert_response :success
  end
end
