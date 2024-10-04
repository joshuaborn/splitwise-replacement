class PersonExpense < ApplicationRecord
  belongs_to :person
  belongs_to :expense
  has_many :person_expenses, through: :expense
  has_many :people, through: :person_expenses, source: :person

  validates :person, presence: true
  validates :expense, presence: true
  validates :amount, presence: true

  before_save :set_cumulative_sums

  def dollar_amount
    self.amount.to_f / 100
  end

  def dollar_amount=(dollars)
    self.amount = (100 * dollars.to_f).to_i
  end

  def other_person_expense
    self.person_expenses.detect { |person_expense| person_expense.person_id != self.person_id }
  end

  def other_person
    self.people.detect { |person| person.id != self.person_id }
  end

  def dollar_cumulative_sum
    self.cumulative_sum.to_f / 100
  end

  class << self
    def find_for_person_with_other_person(first_person, second_person)
      PersonExpense.joins("LEFT OUTER JOIN expenses ON expenses.id = person_expenses.expense_id").
        joins("JOIN person_expenses AS pe2 ON expenses.id = pe2.expense_id").
        where("person_expenses.person_id = ? AND pe2.person_id = ?", first_person, second_person).
        order("expenses.date", "expenses.updated_at")
    end
  end

  private
    def set_cumulative_sums
      other_person = self.expense.person_expenses.detect { |person_expense| person_expense.person_id != self.person_id }.person
      existing_person_expenses = PersonExpense.find_for_person_with_other_person(self.person, other_person)
      if existing_person_expenses.where("expenses.date <= ?", self.expense.date).empty?
        self.cumulative_sum = self.amount
      else
        previous_person_expense = existing_person_expenses.where("expenses.date <= ?", self.expense.date).last
        self.cumulative_sum = self.amount + previous_person_expense.cumulative_sum
      end
      existing_person_expenses.where("expenses.date > ?", self.expense.date).inject(self.cumulative_sum) do |sum, person_expense|
        person_expense.update_columns(cumulative_sum: sum + person_expense.amount)
        person_expense.cumulative_sum
      end
    end
end
