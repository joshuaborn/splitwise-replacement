require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "amount lent cannot be greater in absolute value than amount paid" do
    amount_paid = 9.0
    transaction = Transaction.new(
      first_person: people(:user_one),
      second_person: people(:user_two),
      amount_lent: 10,
      amount_paid: amount_paid
    )
    assert_not transaction.validate
    assert_includes transaction.errors[:absolute_amount_lent], "must be less than or equal to " + amount_paid.to_s
    transaction = Transaction.new(
      first_person: people(:user_one),
      second_person: people(:user_two),
      amount_lent: -10,
      amount_paid: -amount_paid
    )
    assert_not transaction.validate
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
  test "switches associated people if first person's ID is greater than second person's ID" do
    assert people(:user_one).id < people(:user_two).id
    transaction = Transaction.new(
      first_person: people(:user_two),
      second_person: people(:user_one),
      amount_lent: 5,
      amount_paid: 10
    )
    assert transaction.validate
    assert_equal people(:user_one), transaction.first_person
    assert_equal people(:user_two), transaction.second_person
  end
  test "can get all transactions between two people, regardless of argument order" do
    assert people(:user_one).id < people(:user_two).id
    transactions = Transaction.where(first_person: people(:user_one), second_person: people(:user_two))
    assert transactions.present?
    assert_equal transactions, Transaction.find_for_people(people(:user_one), people(:user_two))
    assert_equal transactions, Transaction.find_for_people(people(:user_two), people(:user_one))
  end
end
