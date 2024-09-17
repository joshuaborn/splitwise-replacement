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
  test "can get all transactions for a user, both payer and ower" do
    person = people(:user)
    assert person.ower_transactions.count > 0
    assert person.payer_transactions.count > 0
    combined_transactions = Transaction.find_for_person(person)
    person.ower_transactions.each do |transaction|
       assert_includes combined_transactions, transaction
    end
    person.payer_transactions.each do |transaction|
       assert_includes combined_transactions, transaction
    end
  end
end
