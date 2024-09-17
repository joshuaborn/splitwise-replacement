require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "amount lent cannot be greater in absolute value than amount paid" do
    amount_paid = 9.0
    transaction = Transaction.new(amount_lent: 10, amount_paid: amount_paid)
    transaction.validate
    assert_includes transaction.errors[:absolute_amount_lent], "must be less than or equal to " + amount_paid.to_s
    transaction = Transaction.new(amount_lent: -10, amount_paid: -amount_paid)
    transaction.validate
    assert_includes transaction.errors[:absolute_amount_lent], "must be less than or equal to " + amount_paid.to_s
  end
  test "can get all transactions for a user, regardless of whether user is in first or second spot" do
    person = people(:user_one)
    assert person.transactions_as_first_person.count > 0
    assert person.transactions_as_second_person.count > 0
    combined_transactions = Transaction.find_for_person(person)
    person.transactions_as_first_person.each do |transaction|
       assert_includes combined_transactions, transaction
    end
    person.transactions_as_second_person.each do |transaction|
       assert_includes combined_transactions, transaction
    end
  end
end
