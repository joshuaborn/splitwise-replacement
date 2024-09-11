require "test_helper"

class LoginsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_login_path
    assert_response :success
  end

  test "should be able to login" do
    post logins_path, params: { person_id: people(:administrator).id }

    assert_equal people(:administrator).id, session[:current_user_id]
    assert_redirected_to root_path
  end

  test "should redirect back to login page if user is not found" do
    post logins_path, params: { person_id: 1 }

    assert_nil session[:current_user_id]
    assert_equal "User with ID 1 doesn't exist", flash[:error]
    assert_redirected_to new_login_path
  end

  # test "should get destroy" do
  #  delete logins_destroy_url
  #  assert_nil session[:current_user_id]
  #  assert_redirected_to logins_new_url
  # end
end
