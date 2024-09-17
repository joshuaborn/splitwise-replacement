require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    post login_path, params: { person_id: people(:user_one).id }
    get transactions_path
    assert_response :success
  end
  test "should get redirected to logins#new if no one is logged in" do
    get transactions_path
    assert_equal "Please log in to access this page.", flash[:warning]
    assert_redirected_to new_login_url
  end
end
