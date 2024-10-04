require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    post login_path, params: { person_id: people(:user_one).id }
    get expenses_path
    assert_response :success
  end
  test "should get redirected to logins#new if no one is logged in" do
    get expenses_path
    assert_equal "Please log in to access this page.", flash[:warning]
    assert_redirected_to new_login_url
  end
  test "should get new" do
    post login_path, params: { person_id: people(:user_one).id }
    get new_expense_path
    assert_response :success
  end
  test "should get a list of people with which to create a new transaction who aren't the current user" do
    post login_path, params: { person_id: people(:user_one).id }
    get new_expense_path
    assert_select "select#person_id option" do |elements|
      Person.where.not(id: people(:user_one)).all.each_with_index do |person, i|
        assert_equal elements[i].text, person.name
        assert_equal elements[i].attribute("value").value, person.id.to_s
      end
    end
  end
  test "create when current_user paid and is splitting with other person" do
    post login_path, params: { person_id: people(:user_one).id }
    parameters = {
      person_paid: "current",
      person: { id: people(:user_two).id },
      expense: {
        payee: "Acme, Inc.",
        memo: "widgets",
        date: "2024-09-25",
        dollar_amount_paid: "4.3"
      }
    }
    assert_difference("Expense.count") do
      post expenses_path, params: parameters
    end
    assert_equal "Transaction was successfully created.", flash[:info]
    parameters[:expense].each do |key, val|
      assert_equal val, Expense.last.send(key).to_s
    end
    assert_response :success
    assert_select 'turbo-stream[action="refresh"]'
  end
  test "create when other person paid and is splitting with current_user" do
    post login_path, params: { person_id: people(:user_one).id }
    parameters = {
      person_paid: "other",
      person: { id: people(:user_two).id },
      expense: {
        payee: "Acme, Inc.",
        memo: "widgets",
        date: "2024-09-25",
        dollar_amount_paid: "4.3"
      }
    }
    assert_difference("Expense.count") do
      post expenses_path, params: parameters
    end
    assert_equal "Transaction was successfully created.", flash[:info]
    parameters[:expense].each do |key, val|
      assert_equal val, Expense.last.send(key).to_s
    end
    assert_response :success
    assert_select 'turbo-stream[action="refresh"]'
  end
  test "raises an error person_paid parameter is invalid on create" do
    post login_path, params: { person_id: people(:user_one).id }
    parameters = {
      person_paid: "foobar",
      person: { id: people(:user_two).id },
      expense: {
        payee: "Acme, Inc.",
        memo: "widgets",
        date: "2024-09-25",
        dollar_amount_paid: "4.3"
      }
    }
    assert_no_difference("Expense.count") do
      assert_raises(StandardError) do
        post expenses_path, params: parameters
      end
    end
  end
  test "should get edit" do
    build_expenses_for_tests()
    post login_path, params: { person_id: people(:user_one).id }
    person_expense = people(:user_one).person_expenses.first
    get edit_expense_path(person_expense.id)
    assert_response :success
  end
  test "should error when trying to edit a PersonExpense that is not of the current user's" do
    build_expenses_for_tests()
    post login_path, params: { person_id: people(:user_one).id }
    person_expense = people(:user_two).person_expenses.first
    get edit_expense_path(person_expense.id)
    assert_response :missing
  end
end
