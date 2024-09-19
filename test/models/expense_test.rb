require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "Expense should not validate without at least two valid PersonExpenses" do
    expense = Expense.new(amount_paid: 10.00)
    assert_not expense.valid?
    assert expense.errors[:person_expenses].any?

    expense = Expense.new(amount_paid: 11.00)
    expense.person_expenses.new(person: people(:user_one), amount: 5.50)
    assert_not expense.valid?
    assert expense.errors[:person_expenses].any?

    expense = Expense.new(amount_paid: 11.00)
    expense.person_expenses.new(person: people(:user_one), amount: 5.50)
    expense.person_expenses.new(person: people(:user_two), amount: 5.50)
    assert expense.valid?
    assert_not expense.errors[:person_expenses].any?

    expense = Expense.new(amount_paid: 11.00)
    expense.person_expenses.new(person: people(:user_one), amount: 5.50)
    expense.person_expenses.new(person: people(:user_two))
    assert_not expense.valid?
    assert expense.errors[:person_expenses].any?
  end
end
