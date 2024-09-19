class PersonExpense < ApplicationRecord
  belongs_to :person
  belongs_to :expense

  validates :person, presence: true
  validates :expense, presence: true
  validates :amount, presence: true

  def dollar_amount
    self.amount.to_f / 100
  end

  def dollar_amount=(dollars)
    self.amount = (100 * dollars).to_i
  end

  class << self
    def find_for_person_with_other_person(first_person, second_person)
      PersonExpense.joins("LEFT OUTER JOIN expenses ON expenses.id = person_expenses.expense_id").
        joins("JOIN person_expenses AS pe2 ON expenses.id = pe2.expense_id").
        where("person_expenses.person_id = ? AND pe2.person_id = ?", first_person, second_person)
    end
  end
end
