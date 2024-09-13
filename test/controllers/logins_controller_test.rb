require "test_helper"

class LoginsControllerTest < ActionDispatch::IntegrationTest
  test "should get page to select user for logging in" do
    get new_login_path
    assert_response :success
  end

  test "should be able to login and to logout" do
    post login_path, params: { person_id: people(:administrator).id }

    assert_equal people(:administrator).id, session[:current_user_id]
    assert_redirected_to root_path

    delete login_path

    assert_redirected_to new_login_path
    assert_nil session[:current_user_id]
    assert_nil flash[:danger]
    assert_equal "Logged out.", flash[:info]
  end

  test "should redirect back to login page if user is not found" do
    post login_path, params: { person_id: 1 }

    assert_nil session[:current_user_id]
    assert_equal "User with ID 1 doesn't exist.", flash[:danger]
    assert_redirected_to new_login_path
  end
end
