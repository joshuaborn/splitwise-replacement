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
  test "setting amount_paid in dollars" do
    assert_equal 731, Expense.new(dollar_amount_paid: 7.31).amount_paid
  end
  test "creating an Expense by splitting between two people" do
    expense = Expense.split_between_two_people(people(:user_one), people(:user_two), 10.00)
    expense.save!
    assert_equal 1000, expense.amount_paid
    assert_equal 10.00, expense.dollar_amount_paid
    assert_equal 5.00, expense.person_expenses.where(person: people(:user_one)).first.dollar_amount
    assert_equal (-5.00), expense.person_expenses.where(person: people(:user_two)).first.dollar_amount
    srand(9192024)
    expense = Expense.split_between_two_people(people(:user_one), people(:user_two), 7.31)
    expense.save!
    assert_equal 731, expense.amount_paid
    assert_equal 7.31, expense.dollar_amount_paid
    assert_equal 3.66, expense.person_expenses.where(person: people(:user_one)).first.dollar_amount
    assert_equal (-3.65), expense.person_expenses.where(person: people(:user_two)).first.dollar_amount
    srand(9192027)
    expense = Expense.split_between_two_people(people(:user_one), people(:user_two), 7.31)
    expense.save!
    assert_equal 731, expense.amount_paid
    assert_equal 7.31, expense.dollar_amount_paid
    assert_equal 3.65, expense.person_expenses.where(person: people(:user_one)).first.dollar_amount
    assert_equal (-3.66), expense.person_expenses.where(person: people(:user_two)).first.dollar_amount
  end
  test "getting all and only expenses split between two people" do
    Expense.split_between_two_people(people(:user_one), people(:user_two), 6.52).save!
    Expense.split_between_two_people(people(:user_one), people(:user_two), 8.88).save!
    Expense.split_between_two_people(people(:user_two), people(:user_one), 105.22).save!
    Expense.split_between_two_people(people(:user_two), people(:user_one), 1032.41).save!
    Expense.split_between_two_people(people(:administrator), people(:user_one), 923.23).save!
    Expense.split_between_two_people(people(:user_one), people(:administrator), 28.01).save!
    Expense.split_between_two_people(people(:administrator), people(:user_two), 237.31).save!
    Expense.split_between_two_people(people(:user_two), people(:administrator), 38.45).save!
    expenses = Expense.find_between_two_people(people(:user_one), people(:user_two))
    assert_equal 4, expenses.length
    assert_equal 115303, expenses.inject(0) { |sum, expense| sum + expense.amount_paid }
  end
end
