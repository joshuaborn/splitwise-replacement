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
    assert_equal (-56111), person_expenses.inject(0) { |sum, expense| sum + expense.amount }
  end
  test "getting of PersonExpense associated with other Person" do
    expense = Expense.split_between_two_people(
      people(:user_one),
      people(:user_two),
      payee: "Acme, Inc.",
      date: "2024-09-21",
      dollar_amount_paid: 6.52
    )
    this_person_expense = expense.person_expenses.detect { |person_expense| person_expense.person_id == people(:user_one).id }
    assert_equal people(:user_one), this_person_expense.person
    expense.save!
    assert_equal people(:user_two), this_person_expense.other_person
  end
  test "getting of Person associated Expense associated with this PersonExpense" do
    expense = Expense.split_between_two_people(
      people(:user_one),
      people(:user_two),
      payee: "Acme, Inc.",
      date: "2024-09-21",
      dollar_amount_paid: 6.52
    )
    this_person_expense = expense.person_expenses.detect { |person_expense| person_expense.person_id == people(:user_one).id }
    assert_equal people(:user_one), this_person_expense.person
    expense.save!
    other_person = this_person_expense.other_person()
    assert_equal people(:user_two), other_person
  end
  test "when a PersonExpense is first created between two people, the amount owed becomes the cumulative sum" do
    Expense.split_between_two_people(
      people(:user_one),
      people(:user_two),
      payee: "Acme, Inc.",
      date: "2024-09-21",
      dollar_amount_paid: 6.52
    ).save!
    assert_equal 1, people(:user_one).person_expenses.count
    assert_equal 326, people(:user_one).person_expenses.first.cumulative_sum
    assert_equal 1, people(:user_two).person_expenses.count
    assert_equal (-326), people(:user_two).person_expenses.first.cumulative_sum
  end
  test "when a PersonExpense is saved, its cumulative_sum is set to the sum of the previous PersonExpense's cumulative_sum and this PersonExpense's amount" do
    srand(9192031)
    build_expenses_for_tests()
    person_expenses = PersonExpense.find_for_person_with_other_person(people(:user_one), people(:user_two))
    assert_equal 326, person_expenses[0].cumulative_sum
    assert_equal 770, person_expenses[1].cumulative_sum
    assert_equal (-4491), person_expenses[2].cumulative_sum
    assert_equal (-56112), person_expenses[3].cumulative_sum
    expense = Expense.split_between_two_people(
      people(:user_one),
      people(:user_two),
      payee: "Acme, Inc.",
      date: "2024-09-26",
      dollar_amount_paid: 10.00
    )
    expense.save!
    person_expense = expense.person_expenses.where(person: people(:user_one)).first
    assert_equal (-55612), person_expense.cumulative_sum
  end
  test "when a PersonExpense is saved before another, each's cumulative_sum is set appropriately" do
    srand(9192031)
    build_expenses_for_tests()
    Expense.split_between_two_people(
      people(:user_one),
      people(:user_two),
      payee: "Acme, Inc.",
      date: "2024-09-20",
      dollar_amount_paid: 10.00
    ).save!
    person_expenses = PersonExpense.find_for_person_with_other_person(people(:user_one), people(:user_two))
    assert_equal 326, person_expenses[0].cumulative_sum
    assert_equal 826, person_expenses[1].cumulative_sum
    assert_equal 1270, person_expenses[2].cumulative_sum
    assert_equal (-3991), person_expenses[3].cumulative_sum
    assert_equal (-55612), person_expenses[4].cumulative_sum
  end
  test "when a PersonExpense is saved before all others, its cumulative_sum is set to its own amount" do
    srand(9192031)
    build_expenses_for_tests()
    Expense.split_between_two_people(
      people(:user_one),
      people(:user_two),
      payee: "Acme, Inc.",
      date: "2024-01-01",
      dollar_amount_paid: 2.00
    ).save!
    person_expenses = PersonExpense.find_for_person_with_other_person(people(:user_one), people(:user_two))
    assert_equal 100, person_expenses[0].cumulative_sum
    assert_equal 426, person_expenses[1].cumulative_sum
    assert_equal 870, person_expenses[2].cumulative_sum
    assert_equal (-4391), person_expenses[3].cumulative_sum
    assert_equal (-56012), person_expenses[4].cumulative_sum
  end
  test "getting cumulative_sum in dollars" do
    srand(9192031)
    expense = Expense.split_between_two_people(
      people(:user_one),
      people(:user_two),
      payee: "Acme, Inc.",
      date: "2024-09-21",
      dollar_amount_paid: 6.51
    )
    expense.save!
    assert_equal (-3.26), expense.person_expenses.first.dollar_cumulative_sum
    assert_equal 3.25, expense.person_expenses.last.dollar_cumulative_sum
  end
end
