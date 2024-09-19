require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "Expense should not validate without at least two valid PersonExpenses" do
    expense = Expense.new(amount_paid: 10.00)
    assert_not expense.valid?
    assert_includes expense.errors.messages[:person_expenses], "is too short (minimum is 2 characters)"

    expense = Expense.new(amount_paid: 11.00)
    expense.person_expenses.new(person: people(:user_one), amount: 5.50)
    assert_not expense.valid?
    assert_includes expense.errors.messages[:person_expenses], "is too short (minimum is 2 characters)"

    expense = Expense.new(amount_paid: 11.00)
    expense.person_expenses.new(person: people(:user_one), amount: 5.50)
    expense.person_expenses.new(person: people(:user_two), amount: 5.50)
    assert expense.valid?
    assert_not_includes expense.errors.messages[:person_expenses], "is too short (minimum is 2 characters)"

    expense = Expense.new(amount_paid: 11.00)
    expense.person_expenses.new(person: people(:user_one), amount: 5.50)
    expense.person_expenses.new(person: people(:user_two))
    assert_not expense.valid?
    assert_includes expense.errors.messages[:person_expenses], "is invalid"
  end
  test "getting amount_paid in dollars" do
    assert_equal 7.31, Expense.new(amount_paid: 731).dollar_amount_paid
  end
end
