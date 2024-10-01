require "test_helper"

class ExpensesHelperTest < ActionView::TestCase
  test "grouping of transactions by date" do
    build_expenses_for_tests()
    person_expenses = people(:user_one).person_expenses.includes(:expense, :person_expenses, :people).order(expenses: { date: :desc })
    hashed_person_expenses = group_by_date(person_expenses)
    assert hashed_person_expenses.is_a? Hash
    assert_equal 5, hashed_person_expenses.length
    assert_equal "09/24/2024", hashed_person_expenses.keys.first
  end
end
