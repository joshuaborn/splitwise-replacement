require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "amount lent cannot be greater than amount paid" do
    amount_paid = 9.0
    transaction = Transaction.new(amount_lent: 10, amount_paid: amount_paid)
    transaction.validate
    assert_includes transaction.errors[:amount_lent], "must be less than or equal to " + amount_paid.to_s
  end
  test "amount paid cannot be negative" do
    transaction = Transaction.new(amount_paid: -1)
    transaction.validate
    assert_includes transaction.errors[:amount_paid], "must be greater than or equal to 0"
  end
end
