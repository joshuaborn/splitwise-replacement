class Person < ApplicationRecord
  has_many :transactions_as_first_person, class_name: "Transaction", foreign_key: "first_person_id", dependent: :destroy
  has_many :transactions_as_second_person, class_name: "Transaction", foreign_key: "second_person_id", dependent: :destroy

  validates :name, presence: true

  def transactions
    Transaction.find_for_person(self)
  end
end
