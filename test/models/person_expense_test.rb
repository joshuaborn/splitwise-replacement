require "test_helper"

class PersonExpenseTest < ActiveSupport::TestCase
  test "getting amount in dollars" do
    assert_equal 7.31, PersonExpense.new(amount: 731).dollar_amount
  end
  test "setting amount in dollars" do
    assert_equal 731, PersonExpense.new(dollar_amount: 7.31).amount
  end
  test "getting PersonExpense records for a given person that are with specified other person" do
    srand(9192024)
    build_expenses_for_tests()
    person_expenses = PersonExpense.find_for_person_with_other_person(people(:user_one), people(:user_two))
    person_expenses.each do |person_expense|
      assert_equal people(:user_one), person_expense.person
    end
    assert_equal 4, person_expenses.length
    assert_equal -56111, person_expenses.inject(0) { |sum, expense| sum + expense.amount }
  end
end
