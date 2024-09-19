ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def build_expenses_for_tests
      Expense.split_between_two_people(people(:user_one), people(:user_two), 6.52).save!
      Expense.split_between_two_people(people(:user_one), people(:user_two), 8.88).save!
      Expense.split_between_two_people(people(:user_two), people(:user_one), 105.22).save!
      Expense.split_between_two_people(people(:user_two), people(:user_one), 1032.41).save!
      Expense.split_between_two_people(people(:administrator), people(:user_one), 923.23).save!
      Expense.split_between_two_people(people(:user_one), people(:administrator), 28.01).save!
      Expense.split_between_two_people(people(:administrator), people(:user_two), 237.31).save!
      Expense.split_between_two_people(people(:user_two), people(:administrator), 38.45).save!
    end
  end
end
