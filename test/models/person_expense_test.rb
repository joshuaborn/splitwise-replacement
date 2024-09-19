require "test_helper"

class PersonExpenseTest < ActiveSupport::TestCase
  test "getting amount in dollars" do
    assert_equal 7.31, PersonExpense.new(amount: 731).dollar_amount
  end
  test "setting amount in dollars" do
    assert_equal 731, PersonExpense.new(dollar_amount: 7.31).amount
  end
end
