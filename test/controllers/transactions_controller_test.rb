require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transactions_path
    assert_response :success
  end
end
