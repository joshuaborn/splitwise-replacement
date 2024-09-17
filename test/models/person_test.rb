require "test_helper"

class PersonTest < ActiveSupport::TestCase
   test "should not save without a name" do
      assert_not Person.new.save, "saved the person without a name"
   end
   test "can get all transactions for this person" do
      person = people(:user)
      assert_equal person.transactions, Transaction.find_for_person(person)
   end
end
