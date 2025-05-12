require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should post create" do
    post event_expenses_path(events(:one)), params: { expense: { name: "Test Expense", amount: 1000 } }
    assert_response :redirect
  end

  test "should patch update" do
    patch event_expense_path(events(:one), expenses(:one)), params: { expense: { amount: 2000 } }
    assert_response :redirect
  end

  test "should delete destroy" do
    delete event_expense_path(events(:one), expenses(:one))
    assert_response :redirect
  end
end
