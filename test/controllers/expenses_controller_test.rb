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
end
