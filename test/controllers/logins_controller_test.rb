require "test_helper"

class LoginsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get logins_new_url
    assert_response :success
  end

  test "should be able to login" do
    get logins_create_url, params: { person_id: people(:administrator).id }

    assert_equal people(:administrator).id, session[:current_user_id]
    assert_redirected_to root_url
  end

  test "should redirect back to login page if user is not found" do
    get logins_create_url, params: { person_id: 1 }

    assert_nil session[:current_user_id]
    assert_equal "User with ID 1 doesn't exist", flash[:error]
    assert_redirected_to logins_new_url
  end

  # test "should get destroy" do
  #  get logins_destroy_url
  #  assert_nil session[:current_user_id]
  #  assert_redirected_to logins_new_url
  # end
end
